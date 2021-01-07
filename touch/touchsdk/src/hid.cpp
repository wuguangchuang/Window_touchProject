/*******************************************************
 HIDAPI - Multi-Platform library for
 communication with HID devices.

 Alan Ott
 Signal 11 Software

 8/22/2009

 Copyright 2009, All Rights Reserved.

 At the discretion of the user of this library,
 this software may be licensed under the terms of the
 GNU Public License v3, a BSD-Style license, or the
 original HIDAPI license as outlined in the LICENSE.txt,
 LICENSE-gpl3.txt, LICENSE-bsd.txt, and LICENSE-orig.txt
 files located at the root of the source distribution.
 These files may also be found in the public source
 code repository located at:
        http://github.com/signal11/hidapi .
********************************************************/

#include <windows.h>
#include "CommandThread.h"

#ifndef _NTDEF_
typedef LONG NTSTATUS;
#endif

#ifdef __MINGW32__
#include <ntdef.h>
#include <winbase.h>
#endif

#ifdef __CYGWIN__
#include <ntdef.h>
#define _wcsdup wcsdup
#endif

//#define HIDAPI_USE_DDK
#include "touch.h"
#include "utils/tdebug.h"

#define DEFAULT_REPORT_LENGTH (64)

/*
#ifdef __cplusplus
extern "C" {
#endif
*/
    #include <setupapi.h>
    #include <winioctl.h>
    #ifdef HIDAPI_USE_DDK
        #include <hidsdi.h>
    #endif


    // Copied from inc/ddk/hidclass.h, part of the Windows DDK.
    #define HID_OUT_CTL_CODE(id)  \
        CTL_CODE(FILE_DEVICE_KEYBOARD, (id), METHOD_OUT_DIRECT, FILE_ANY_ACCESS)
    #define IOCTL_HID_GET_FEATURE                   HID_OUT_CTL_CODE(100)
/*
#ifdef __cplusplus
} // extern "C"
#endif
*/

#include <stdio.h>
#include <stdlib.h>

#include  <QThread>
#include "hidapi.h"

#ifdef _MSC_VER
    // Thanks Microsoft, but I know how to use strncpy().
    #pragma warning(disable:4996)
#endif

/*
#ifdef __cplusplus
extern "C" {
#endif
*/

#ifndef HIDAPI_USE_DDK
    // Since we're not building with the DDK, and the HID header
    // files aren't part of the SDK, we have to define all this
    // stuff here. In lookup_functions(), the function pointers
    // defined below are set.
    typedef struct _HIDD_ATTRIBUTES{
        ULONG Size;
        USHORT VendorID;
        USHORT ProductID;
        USHORT VersionNumber;
    } HIDD_ATTRIBUTES, *PHIDD_ATTRIBUTES;

    typedef USHORT USAGE;
    typedef struct _HIDP_CAPS {
        USAGE Usage;
        USAGE UsagePage;
        USHORT InputReportByteLength;
        USHORT OutputReportByteLength;
        USHORT FeatureReportByteLength;
        USHORT Reserved[17];
        USHORT fields_not_used_by_hidapi[10];
    } HIDP_CAPS, *PHIDP_CAPS;
    typedef char* HIDP_PREPARSED_DATA;
    #define HIDP_STATUS_SUCCESS 0x0

    typedef BOOLEAN (__stdcall *HidD_GetAttributes_)(HANDLE device, PHIDD_ATTRIBUTES attrib);
    typedef BOOLEAN (__stdcall *HidD_GetSerialNumberString_)(HANDLE device, PVOID buffer, ULONG buffer_len);
    typedef BOOLEAN (__stdcall *HidD_GetManufacturerString_)(HANDLE handle, PVOID buffer, ULONG buffer_len);
    typedef BOOLEAN (__stdcall *HidD_GetProductString_)(HANDLE handle, PVOID buffer, ULONG buffer_len);
    typedef BOOLEAN (__stdcall *HidD_SetFeature_)(HANDLE handle, PVOID data, ULONG length);
    typedef BOOLEAN (__stdcall *HidD_GetFeature_)(HANDLE handle, PVOID data, ULONG length);
    typedef BOOLEAN (__stdcall *HidD_GetIndexedString_)(HANDLE handle, ULONG string_index, PVOID buffer, ULONG buffer_len);
    typedef BOOLEAN (__stdcall *HidD_GetPreparsedData_)(HANDLE handle, HIDP_PREPARSED_DATA **preparsed_data);
    typedef BOOLEAN (__stdcall *HidD_FreePreparsedData_)(HIDP_PREPARSED_DATA *preparsed_data);
    typedef BOOLEAN (__stdcall *HidP_GetCaps_)(HIDP_PREPARSED_DATA *preparsed_data, HIDP_CAPS *caps);

    static HidD_GetAttributes_ HidD_GetAttributes;
    static HidD_GetSerialNumberString_ HidD_GetSerialNumberString;
    static HidD_GetManufacturerString_ HidD_GetManufacturerString;
    static HidD_GetProductString_ HidD_GetProductString;
    static HidD_SetFeature_ HidD_SetFeature;
    static HidD_GetFeature_ HidD_GetFeature;
    static HidD_GetIndexedString_ HidD_GetIndexedString;
    static HidD_GetPreparsedData_ HidD_GetPreparsedData;
    static HidD_FreePreparsedData_ HidD_FreePreparsedData;
    static HidP_GetCaps_ HidP_GetCaps;

    static HMODULE lib_handle = NULL;
    static BOOLEAN initialized = FALSE;
#endif // HIDAPI_USE_DDK

struct hid_device_ {
        HANDLE device_handle;
        BOOL blocking;
        size_t input_report_length;
        void *last_error_str;
        DWORD last_error_num;
        BOOL read_pending;
        char *read_buf;
        OVERLAPPED ol;
        struct hid_device_info *info;
        size_t output_report_length;
};


static hid_device *new_hid_device()
{
    hid_device *dev = (hid_device*) calloc(1, sizeof(hid_device));
    dev->device_handle = INVALID_HANDLE_VALUE;
    dev->blocking = TRUE;
    dev->input_report_length = 0;
    dev->last_error_str = NULL;
    dev->last_error_num = 0;
    dev->read_pending = FALSE;
    dev->read_buf = NULL;
    memset(&dev->ol, 0, sizeof(dev->ol));
    dev->ol.hEvent = CreateEvent(NULL, FALSE, FALSE /*inital state f=nonsignaled*/, NULL);

    return dev;
}


static void register_error(hid_device *device, const char *op)
{
    WCHAR *ptr, *msg;

    FormatMessageW(FORMAT_MESSAGE_ALLOCATE_BUFFER |
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        GetLastError(),
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPWSTR)&msg, 0/*sz*/,
        NULL);

    // Get rid of the CR and LF that FormatMessage() sticks at the
    // end of the message. Thanks Microsoft!
    ptr = msg;
    while (*ptr) {
        if (*ptr == '\r') {
            *ptr = 0x0000;
            break;
        }
        ptr++;
    }

    // Store the message off in the Device entry so that
    // the hid_error() function can pick it up.
    LocalFree(device->last_error_str);
    device->last_error_str = msg;
}

#ifndef HIDAPI_USE_DDK
static int lookup_functions()
{
    lib_handle = LoadLibraryA("hid.dll");
    if (lib_handle) {
#define RESOLVE(x) x = (x##_)GetProcAddress(lib_handle, #x); if (!x) return -1;
        RESOLVE(HidD_GetAttributes);
        RESOLVE(HidD_GetSerialNumberString);
        RESOLVE(HidD_GetManufacturerString);
        RESOLVE(HidD_GetProductString);
        RESOLVE(HidD_SetFeature);
        RESOLVE(HidD_GetFeature);
        RESOLVE(HidD_GetIndexedString);
        RESOLVE(HidD_GetPreparsedData);
        RESOLVE(HidD_FreePreparsedData);
        RESOLVE(HidP_GetCaps);
#undef RESOLVE
    }
    else
        return -1;

    return 0;
}
#endif

static HANDLE open_device(const char *path)
{
    HANDLE handle;

    /* First, try to open with sharing mode turned off. This will make it so
       that a HID device can only be opened once. This is to be consistent
       with the behavior on the other platforms. */
    handle = CreateFileA(path,
        GENERIC_WRITE |GENERIC_READ,
        0, /*share mode*/
        NULL,
        OPEN_EXISTING,
        FILE_FLAG_OVERLAPPED,//FILE_ATTRIBUTE_NORMAL,
        0);

    if (handle == INVALID_HANDLE_VALUE) {
        /* Couldn't open the device. Some devices must be opened
           with sharing enabled (even though they are only opened once),
           so try it here. */
        handle = CreateFileA(path,
            GENERIC_WRITE |GENERIC_READ,
            FILE_SHARE_READ|FILE_SHARE_WRITE, /*share mode*/
            NULL,
            OPEN_EXISTING,
            FILE_FLAG_OVERLAPPED,//FILE_ATTRIBUTE_NORMAL,
            0);
    }

    return handle;
}

int HID_API_EXPORT hid_init(void)
{
#ifndef HIDAPI_USE_DDK
    if (!initialized) {
        if (lookup_functions() < 0) {
            hid_exit();
            return -1;
        }
        initialized = TRUE;
    }
#endif
    return 0;
}

int HID_API_EXPORT hid_exit(void)
{
#ifndef HIDAPI_USE_DDK
    if (lib_handle)
        FreeLibrary(lib_handle);
    lib_handle = NULL;
    initialized = FALSE;
#endif
    return 0;
}
void HID_API_EXPORT * HID_API_CALL free_touchdevice(touch_device *devices)
{
    touch_device *tmp = NULL;
    while (devices) {
        if (devices->hid) {
            devices->hid = NULL;
            hid_close(devices->hid);
        }
        if (devices->info) {
            devices->info->next = NULL;
            hid_free_enumeration(devices->info);
        }
        tmp = devices->next;
        free(devices);
        devices = tmp;
    }
    return NULL;
}

struct hid_device_info HID_API_EXPORT * HID_API_CALL hid_enumerate(unsigned short vendor_id, unsigned short product_id)
{
    return NULL;
}

// support devices
static struct touch_vendor_info default_vendor_touchs[] = {
{0xAED7, 0x0013, "col01", 0xCD, 0},
{0xAED7, 0xFEDC, "col01", 0xCD, 1},
{NULL},
};

typedef struct _touch_vendor_list {
        struct touch_vendor_info *info;
            struct _touch_vendor_list *next;
}touch_vendor_list;

static touch_vendor_list *vendor_list = NULL;

int touch_vendor_add(struct touch_vendor_info *info)
{
    touch_vendor_list *vendor = (touch_vendor_list*)malloc(sizeof(touch_vendor_list));
    touch_vendor_list *next = NULL;
    if (info == NULL)
        return -1;

    vendor->info = (struct touch_vendor_info*)malloc(sizeof(struct touch_vendor_info));
    memcpy(vendor->info, info, sizeof(struct touch_vendor_info));
    if (vendor_list) {
        next = vendor_list->next;
        vendor_list->next = vendor;
    } else {
        vendor_list = vendor;
    }

//    TDEBUG("add touch vendor info: vid=0x%04x,pid=0x%04x,path=%s", vendor->info->vid, vendor->info->pid, vendor->info->path);
    vendor->next = next;
    return 0;
}

int touch_vendor_remove(struct touch_vendor_info *info)
{
    touch_vendor_list *vendor = vendor_list;
    touch_vendor_list *next = NULL;
    touch_vendor_list *prev = NULL;
    if (info == NULL)
        return -1;

    while (vendor) {
        next = vendor->next;
        if (info == vendor->info) {
            // first
            if (vendor == vendor_list) {
                vendor_list = vendor->next;
                free(vendor);
                return 0;
            } else {
                if (prev) {
                    prev->next = vendor->next;
                    free(vendor);
                    return 0;
                }
            }
        }
        prev = vendor;
        vendor = next;
    }
    return -2;
}

void touch_vendor_remove_all(void)
{
    touch_vendor_list *vendor = vendor_list;
    touch_vendor_list *temp = NULL;
    while (vendor) {
        temp = vendor->next;
        free(vendor);
        vendor = temp;
    }
}

//寻找触摸屏设备
touch_device *HID_API_EXPORT HID_API_CALL hid_find_touchdevice(int *count)
{
    BOOL res;
    struct hid_device_info *root = NULL; // return object
    struct hid_device_info *cur_dev = NULL;
    int vendor_touch_count = sizeof(default_vendor_touchs) / sizeof(struct touch_vendor_info);
    struct touch_vendor_info *temp_vendor;
    touch_device *device, *root_device = NULL, *tmp_device = NULL;
    int found = 0;
    int touchCount = 0;

    // Windows objects for interacting with the driver.
    GUID InterfaceClassGuid = {0x4d1e55b2, 0xf16f, 0x11cf, {0x88, 0xcb, 0x00, 0x11, 0x11, 0x00, 0x00, 0x30} };
    SP_DEVINFO_DATA devinfo_data;
    SP_DEVICE_INTERFACE_DATA device_interface_data;
    SP_DEVICE_INTERFACE_DETAIL_DATA_A *device_interface_detail_data = NULL;
    HDEVINFO device_info_set = INVALID_HANDLE_VALUE;
    int device_index = 0;

    HANDLE write_handle = INVALID_HANDLE_VALUE;
    DWORD required_size = 0;
    HIDD_ATTRIBUTES attrib;


    #define WSTR_LEN 512
    const char *str;
    struct hid_device_info *tmp;
    HIDP_PREPARSED_DATA *pp_data = NULL;
    HIDP_CAPS caps;
    NTSTATUS nt_res;
    wchar_t wstr[WSTR_LEN]; // TODO: Determine Size
    size_t len;

    char pathTemp[128];
    int pathLength;

    touch_vendor_list *vendor = NULL;

    if (hid_init() < 0)
        return NULL;

    // Initialize the Windows objects.
    devinfo_data.cbSize = sizeof(SP_DEVINFO_DATA);
    device_interface_data.cbSize = sizeof(SP_DEVICE_INTERFACE_DATA);

    // Get information for all the devices belonging to the HID class.
    device_info_set = SetupDiGetClassDevsA(&InterfaceClassGuid, NULL, NULL, DIGCF_PRESENT | DIGCF_DEVICEINTERFACE);

    // Iterate over each device in the HID class, looking for the right one.

    for (;;) {

        res = SetupDiEnumDeviceInterfaces(device_info_set,
            NULL,
            &InterfaceClassGuid,
            device_index,
            &device_interface_data);

        if (!res) {
            // A return of FALSE from this function means that
            // there are no more devices.
            break;
        }

        // Call with 0-sized detail size, and let the function
        // tell us how long the detail struct needs to be. The
        // size is put in &required_size.
        res = SetupDiGetDeviceInterfaceDetailA(device_info_set,
            &device_interface_data,
            NULL,
            0,
            &required_size,
            NULL);

        // Allocate a long enough structure for device_interface_detail_data.
        device_interface_detail_data = (SP_DEVICE_INTERFACE_DETAIL_DATA_A*) malloc(required_size);
        device_interface_detail_data->cbSize = sizeof(SP_DEVICE_INTERFACE_DETAIL_DATA_A);

        // Get the detailed data for this device. The detail data gives us
        // the device path for this device, which is then passed into
        // CreateFile() to get a handle to the device.
        res = SetupDiGetDeviceInterfaceDetailA(device_info_set,
            &device_interface_data,
            device_interface_detail_data,
            required_size,
            NULL,
            NULL);

        if (!res) {
            //register_error(dev, "Unable to call SetupDiGetDeviceInterfaceDetail");
            TERROR("Unable to call SetupDiGetDeviceInterfaceDetail");
            // Continue to the next device.
            goto cont;
        }

        //wprintf(L"HandleName: %s\n", device_interface_detail_data->DevicePath);

        // Open a handle to the device
        write_handle = open_device(device_interface_detail_data->DevicePath);

        // Check validity of write_handle.
        if (write_handle == INVALID_HANDLE_VALUE) {
            // Unable to open the device.
            //register_error(dev, "CreateFile");
            TVERBOSE("Unable to open the device(%s, %d)", device_interface_detail_data->DevicePath, GetLastError());
            goto cont_close;
        }


        // Get the Vendor ID and Product ID for this device.
        attrib.Size = sizeof(HIDD_ATTRIBUTES);
        HidD_GetAttributes(write_handle, & attrib);
        TVERBOSE("Vendor/Product: %x/%x (%s)", attrib.VendorID, attrib.ProductID, device_interface_detail_data->DevicePath);

        // Check the VID/PID to see if we should add this
        // device to the enumeration list.
        found = 0;
        //        printf("HID: 0x%x 0x%x, %s\n", attrib.VendorID, attrib.ProductID, device_interface_detail_data->DevicePath);
        if (attrib.VendorID != 0 && attrib.ProductID != 0) {
            for (int i = 0; i < vendor_touch_count; i++) {
                temp_vendor = &default_vendor_touchs[i];
                if (temp_vendor == NULL) break;

                if (temp_vendor->vid == attrib.VendorID && temp_vendor->pid == attrib.ProductID
                        && strstr(device_interface_detail_data->DevicePath, temp_vendor->path) != NULL) {
                    found = 1;
                    break;
                }
            }

            vendor = vendor_list;
            while (vendor) {
                temp_vendor = vendor->info;

                if (temp_vendor->vid == attrib.VendorID && temp_vendor->pid == attrib.ProductID
                        && strstr(device_interface_detail_data->DevicePath, temp_vendor->path) != NULL) {
                    found = 1;
    //                qDebug("vid:=%x, pid=%x, bootloader=%d, repord_id=0x%x, path=%s\n",
    //                       temp_vendor->vid, temp_vendor->pid,
    //                       temp_vendor->bootloader, temp_vendor->rid, temp_vendor->path);
                    break;
                }
                vendor = vendor->next;
            }
        }

        if (found && temp_vendor != NULL) {
            TVERBOSE("## %d,  vid:=%x, pid=%x, bootloader=%d, repord_id=0x%x, path=%s\n",
                     found,
                     temp_vendor->vid, temp_vendor->pid,
                     temp_vendor->bootloader, temp_vendor->rid, temp_vendor->path);
        }

        if (found) {
            TDEBUG("device_interface_detail_data->DevicePathh = %s",device_interface_detail_data->DevicePath);
            device = (touch_device*)malloc(sizeof(touch_device));
            memset(device, 0, sizeof(touch_device));
            /* VID/PID match. Create the record. */
            tmp = (struct hid_device_info*) calloc(1, sizeof(struct hid_device_info));
            if (cur_dev) {
                cur_dev->next = tmp;
            }
            else {
                root = tmp;
            }
            cur_dev = tmp;

            // Get the Usage Page and Usage for this device.
            res = HidD_GetPreparsedData(write_handle, &pp_data);
            if (res) {
                nt_res = HidP_GetCaps(pp_data, &caps);
                if (nt_res == HIDP_STATUS_SUCCESS) {
                    cur_dev->usage_page = caps.UsagePage;
                    cur_dev->usage = caps.Usage;
                }

                HidD_FreePreparsedData(pp_data);
            }

            /* Fill out the record */
            cur_dev->next = NULL;
            str = device_interface_detail_data->DevicePath;
            if (str) {
                len = strlen(str);
                cur_dev->path = (char*) calloc(len+1, sizeof(char));
                strncpy(cur_dev->path, str, len+1);
                cur_dev->path[len] = '\0';
            }
            else
                cur_dev->path = NULL;

            /* Serial Number */
//            res = HidD_GetSerialNumberString(write_handle, wstr, sizeof(wstr));
//            wstr[WSTR_LEN-1] = 0x0000;
//            if (res) {
//                cur_dev->serial_number = _wcsdup(wstr);
//            }

//            /* Manufacturer String */
//            res = HidD_GetManufacturerString(write_handle, wstr, sizeof(wstr));
//            wstr[WSTR_LEN-1] = 0x0000;
//            if (res) {
//                cur_dev->manufacturer_string = _wcsdup(wstr);
//            }

//            /* Product String */
//            res = HidD_GetProductString(write_handle, wstr, sizeof(wstr));
//            wstr[WSTR_LEN-1] = 0x0000;
//            if (res) {
//                cur_dev->product_string = _wcsdup(wstr);
//            }

            /* VID/PID */
            cur_dev->vendor_id = attrib.VendorID;
            cur_dev->product_id = attrib.ProductID;

            /* Release Number */
            cur_dev->release_number = attrib.VersionNumber;

            /* Interface Number. It can sometimes be parsed out of the path
               on Windows if a device has multiple interfaces. See
               http://msdn.microsoft.com/en-us/windows/hardware/gg487473 or
               search for "Hardware IDs for HID Devices" at MSDN. If it's not
               in the path, it's set to -1. */
            cur_dev->interface_number = -1;
            if (cur_dev->path) {
                char *interface_component = strstr(cur_dev->path, "&mi_");
                if (interface_component) {
                    char *hex_str = interface_component + 4;
                    char *endptr = NULL;
                    cur_dev->interface_number = strtol(hex_str, &endptr, 16);
                    if (endptr == hex_str) {
                        /* The parsing failed. Set interface_number to -1. */
                        cur_dev->interface_number = -1;
                    }
                }
            }
            device->next = tmp_device;
            device->info = cur_dev;
            if (temp_vendor != NULL) {
                device->touch.report_id = temp_vendor->rid;
                device->touch.booloader = temp_vendor->bootloader;
            }
            device->touch.connected = 1;

            tmp_device = device;

            touchCount++;
        }

cont_close:
        CloseHandle(write_handle);
cont:
        // We no longer need the detail data. It can be freed
        free(device_interface_detail_data);

        device_index++;

    }

    // Close the device information handle.
    SetupDiDestroyDeviceInfoList(device_info_set);
    root_device = tmp_device;
    tmp_device = root_device;
    while (tmp_device) {
        TDEBUG("try %s", tmp_device->info->path);
        tmp_device->hid = hid_open_path(tmp_device->info->path);
        if (tmp_device->hid != NULL)
            tmp_device->touch.output_report_length = tmp_device->hid->output_report_length;
        else
            tmp_device->touch.output_report_length = DEFAULT_REPORT_LENGTH;
        tmp_device = tmp_device->next;
    }
//    for (int i = 0; i < touchCount; i++) {
//        devices[i].hid = hid_open_path(devices[i].info->path);
//    }

    if (count != NULL)
        *count = touchCount;
    return root_device;

}


void  HID_API_EXPORT HID_API_CALL hid_free_enumeration(struct hid_device_info *devs)
{
    // TODO: Merge this with the Linux version. This function is platform-independent.
    struct hid_device_info *d = devs;
    while (d) {
        struct hid_device_info *next = d->next;
        free(d->path);
        free(d->serial_number);
        free(d->manufacturer_string);
        free(d->product_string);
        free(d);
        d = next;
    }
}




HID_API_EXPORT hid_device * HID_API_CALL hid_open_with_path(unsigned short vendor_id, unsigned short product_id, char *path)
{
    // TODO: Merge this functions with the Linux version. This function should be platform independent.
    struct hid_device_info *devs, *cur_dev, *info;
    const char *path_to_open = NULL;
    hid_device *handle = NULL;

    devs = hid_enumerate(vendor_id, product_id);
    cur_dev = devs;
    while (cur_dev) {
        if (cur_dev->vendor_id == vendor_id &&
            cur_dev->product_id == product_id) {
            if (path) {
                if (strstr(cur_dev->path, path) != NULL) {
                    path_to_open = cur_dev->path;
                    cur_dev->report_id = 0xfc;
                    break;
                }
            }
            else {
                path_to_open = cur_dev->path;
                break;
            }
        }
        cur_dev = cur_dev->next;
    }

    if (path_to_open) {
        /* Open the device */
        handle = hid_open_path(path_to_open);
        info = (struct hid_device_info*)malloc(sizeof(struct hid_device_info));
        memcpy(info, cur_dev, sizeof(struct hid_device_info));
        info->next = NULL;
        handle->info = info;
    }

    hid_free_enumeration(devs);

    return handle;
}
HID_API_EXPORT struct hid_device_info * HID_API_CALL hid_get_info(hid_device *dev)
{
    if (dev == NULL)
        return NULL;
    return dev->info;
}
int hidReadTimeOut = 3000;
int hid_send_data(hid_device *dev, struct hid_report_data *data, struct hid_report_data *back)
{
    if (data == NULL)
        return -1;
    if (dev != NULL && dev->info != NULL) {
        data->report_id = dev->info->report_id;
    }

    // Clear data buffer
    int r = 1;
//    int count = 10;
    r = 1;

    while (r > 0) {
        r = hid_read_timeout(dev, (unsigned char*)back, HID_REPORT_DATA_LENGTH, 0);
    }
    int ret = hid_write(dev, (unsigned char*)data, sizeof(struct hid_report_data));
    if (back == NULL)
        return ret;
    if (ret < 0)
        return ret;
    hid_set_nonblocking(dev, 0);
    // FIXME: for this touch device, report id is in back data;
    //back->report_id = data->report_id;

   ret = hid_read_timeout(dev, (unsigned char*)back, HID_REPORT_DATA_LENGTH, 0);

    return ret;
}

HID_API_EXPORT hid_device * HID_API_CALL hid_open(unsigned short vendor_id, unsigned short product_id, wchar_t *serial_number)
{
    // TODO: Merge this functions with the Linux version. This function should be platform independent.
    struct hid_device_info *devs, *cur_dev;
    const char *path_to_open = NULL;
    hid_device *handle = NULL;

    devs = hid_enumerate(vendor_id, product_id);
    cur_dev = devs;
    int i = 0;
    while (cur_dev) {
        if (cur_dev->vendor_id == vendor_id &&
            cur_dev->product_id == product_id) {
            //printf("path:%s\n", (char*)cur_dev->path);
            printf("release number:%x\n", cur_dev->release_number);
            //wprintf("serial_number:%s\n", cur_dev->serial_number);
            if (serial_number) {
                if (wcscmp(serial_number, cur_dev->serial_number) == 0) {
                    path_to_open = cur_dev->path;
                    //break;
                }
            }
            else {
                path_to_open = cur_dev->path;
                if (i++ == 3)
                break;
            }
        }
        cur_dev = cur_dev->next;
    }

    if (path_to_open) {
        /* Open the device */
        handle = hid_open_path(path_to_open);
    }

    hid_free_enumeration(devs);

    return handle;
}

HID_API_EXPORT hid_device * HID_API_CALL hid_open_path(const char *path)
{
    hid_device *dev;
    HIDP_CAPS caps;
    HIDP_PREPARSED_DATA *pp_data = NULL;
    BOOLEAN res;
    NTSTATUS nt_res;

    if (hid_init() < 0) {
        return NULL;
    }

    dev = new_hid_device();

    // Open a handle to the device
    dev->device_handle = open_device(path);

    // Check validity of write_handle.
    if (dev->device_handle == INVALID_HANDLE_VALUE) {
        // Unable to open the device.
        //register_error(dev, "CreateFile");
        TERROR("CreateFile (%s, %d)", path, GetLastError());
        goto err;
    }

    // Get the Input Report length for the device.
    res = HidD_GetPreparsedData(dev->device_handle, &pp_data);
    if (!res) {
        //register_error(dev, "HidD_GetPreparsedData");
        TERROR("HidD_GetPreparsedData (%s, %d)", path, GetLastError());
        //dev->input_report_length = dev->output_report_length = DEFAULT_REPORT_LENGTH;
        goto err;
    } else {
        nt_res = HidP_GetCaps(pp_data, &caps);
        if (nt_res != HIDP_STATUS_SUCCESS) {
            //register_error(dev, "HidP_GetCaps");
            TERROR("HidP_GetCaps (%s, %d)", path, GetLastError());
            goto err_pp_data;
        }
        dev->input_report_length = caps.InputReportByteLength;
        dev->output_report_length = caps.OutputReportByteLength;
    }
    HidD_FreePreparsedData(pp_data);

    dev->read_buf = (char*) malloc(dev->input_report_length);

    return dev;

err_pp_data:
        HidD_FreePreparsedData(pp_data);
err:
        TDEBUG("打开设备失败");
        CloseHandle(dev->device_handle);
        free(dev);
        return NULL;
}

int HID_API_EXPORT HID_API_CALL hid_write(hid_device *dev, const unsigned char *data, size_t length)
{
    DWORD bytes_written;
    BOOL res;

    OVERLAPPED ol;
    memset(&ol, 0, sizeof(ol));
    ol.Offset = 0;
    ol.OffsetHigh = 0;
    ol.hEvent = CreateEvent(NULL, 1, 1, NULL);
    if (dev->device_handle == INVALID_HANDLE_VALUE) {
        TERROR("device handle (%d)", GetLastError());
        return -1;
    }
    size_t outLength = length > dev->output_report_length ? dev->output_report_length : length;
    res = WriteFile(dev->device_handle, data, outLength, NULL, &ol);
    if (!res) {
        if (GetLastError() != ERROR_IO_PENDING) {
            // WriteFile() failed. Return error.
            //register_error(dev, "WriteFile");
            TERROR("WriteFile failed(%d)", GetLastError());
            return -1;
        }
    }

    // Wait here until the write is done. This makes
    // hid_write() synchronous.
    res = GetOverlappedResult(dev->device_handle, &ol, &bytes_written, TRUE/*wait*/);
    if (!res) {
        // The Write operation failed.
//		register_error(dev, "WriteFile");
        TERROR("GetOverlappedResult failed(%d)", GetLastError());
        return -1;
    }

    return bytes_written;
}


int HID_API_EXPORT HID_API_CALL hid_read_timeout(hid_device *dev, unsigned char *data, size_t length, int milliseconds)
{
    DWORD bytes_read = 0;
    BOOL res;

    // Copy the handle for convenience.
    HANDLE ev = dev->ol.hEvent;

    if (!dev->read_pending) {
        // Start an Overlapped I/O read.
        dev->read_pending = TRUE;
        ResetEvent(ev);
        res = ReadFile(dev->device_handle, dev->read_buf, dev->input_report_length, &bytes_read, &dev->ol);
        if (!res) {
            if (GetLastError() != ERROR_IO_PENDING) {
                // ReadFile() has failed.
                // Clean up and return error.
                TERROR("ReadFile failed(%d)", GetLastError());
                CancelIo(dev->device_handle);
                if(dev != NULL)
                {
                    dev->read_pending = FALSE;
                }

                goto end_of_function;
            }
        }
    }

    if (milliseconds > 0) {
        for(int i = 0;i < milliseconds;i++)
        {
            res = WaitForSingleObject(ev, 1);
            if(res == WAIT_OBJECT_0)
                break;
        }
        if (res != WAIT_OBJECT_0) {
            // There was no data this time. Return zero bytes available,
            // but leave the Overlapped I/O running.
    //            TERROR("There was no data this time(%d)", GetLastError());
            return 0;
        }
    }
    if(milliseconds == 0)
    {
        // See if there is any data yet.
        res = WaitForSingleObject(ev, milliseconds);

        if (res != WAIT_OBJECT_0) {
            // There was no data this time. Return zero bytes available,
            // but leave the Overlapped I/O running.
    //            TERROR("There was no data this time(%d)", GetLastError());
            return 0;
        }
    }

    // Either WaitForSingleObject() told us that ReadFile has completed, or
    // we are in non-blocking mode. Get the number of bytes read. The actual
    // data has been copied to the data[] array which was passed to ReadFile().
    res = GetOverlappedResult(dev->device_handle, &dev->ol, &bytes_read, TRUE/*wait*/);
    // Set pending back to false, even if GetOverlappedResult() returned error.
    dev->read_pending = FALSE;

    if (res && bytes_read > 0) {
        if (dev->read_buf[0] == 0x0) {
            /* If report numbers aren't being used, but Windows sticks a report
               number (0x0) on the beginning of the report anyway. To make this
               work like the other platforms, and to make it work more like the
               HID spec, we'll skip over this byte. */
            bytes_read--;
            memcpy(data, dev->read_buf+1, length);
        }
        else {
            /* Copy the whole buffer, report number and all. */
            memcpy(data, dev->read_buf, length);
        }
    }

end_of_function:
    if (!res) {
        return -1;
    }

    return bytes_read;
}


int HID_API_EXPORT HID_API_CALL hid_read(hid_device *dev, unsigned char *data, size_t length)
{
    return hid_read_timeout(dev, data, length, (dev->blocking)? -1: 0);
}

int HID_API_EXPORT HID_API_CALL hid_set_nonblocking(hid_device *dev, int nonblock)
{
    dev->blocking = !nonblock;
    return 0; /* Success */
}

int HID_API_EXPORT HID_API_CALL hid_check(touch_device *dev)
{
    HIDD_ATTRIBUTES hidAttributes;
    return HidD_GetAttributes(dev->hid->device_handle, &hidAttributes);
}

int HID_API_EXPORT HID_API_CALL hid_send_feature_report(hid_device *dev, const unsigned char *data, size_t length)
{
    BOOL res = HidD_SetFeature(dev->device_handle, (PVOID)data, length);
    if (!res) {
        register_error(dev, "HidD_SetFeature");
        return -1;
    }

    return length;
}


int HID_API_EXPORT HID_API_CALL hid_get_feature_report(hid_device *dev, unsigned char *data, size_t length)
{
    BOOL res;
#if 0
    res = HidD_GetFeature(dev->device_handle, data, length);
    if (!res) {
        register_error(dev, "HidD_GetFeature");
        return -1;
    }
    return 0; /* HidD_GetFeature() doesn't give us an actual length, unfortunately */
#else
    DWORD bytes_returned;

    OVERLAPPED ol;
    memset(&ol, 0, sizeof(ol));

    res = DeviceIoControl(dev->device_handle,
        IOCTL_HID_GET_FEATURE,
        data, length,
        data, length,
        &bytes_returned, &ol);

    if (!res) {
        if (GetLastError() != ERROR_IO_PENDING) {
            // DeviceIoControl() failed. Return error.
            register_error(dev, "Send Feature Report DeviceIoControl");
            return -1;
        }
    }

    // Wait here until the write is done. This makes
    // hid_get_feature_report() synchronous.
    res = GetOverlappedResult(dev->device_handle, &ol, &bytes_returned, TRUE/*wait*/);
    if (!res) {
        // The operation failed.
        register_error(dev, "Send Feature Report GetOverLappedResult");
        return -1;
    }
    return bytes_returned;
#endif
}

void HID_API_EXPORT HID_API_CALL hid_close(hid_device *dev)
{
    if (!dev)
        return;
    CancelIo(dev->device_handle);
    CloseHandle(dev->ol.hEvent);
    CloseHandle(dev->device_handle);
    LocalFree(dev->last_error_str);
    free(dev->read_buf);
    if (dev->info)
        hid_free_enumeration(dev->info);
    free(dev);
}

int HID_API_EXPORT_CALL HID_API_CALL hid_get_manufacturer_string(hid_device *dev, wchar_t *string, size_t maxlen)
{
    BOOL res;

    res = HidD_GetManufacturerString(dev->device_handle, string, 2 * maxlen);
    if (!res) {
        register_error(dev, "HidD_GetManufacturerString");
        return -1;
    }

    return 0;
}

int HID_API_EXPORT_CALL HID_API_CALL hid_get_product_string(hid_device *dev, wchar_t *string, size_t maxlen)
{
    BOOL res;

    res = HidD_GetProductString(dev->device_handle, string, 2 * maxlen);
    if (!res) {
        register_error(dev, "HidD_GetProductString");
        return -1;
    }

    return 0;
}

int HID_API_EXPORT_CALL HID_API_CALL hid_get_serial_number_string(hid_device *dev, wchar_t *string, size_t maxlen)
{
    BOOL res;

    res = HidD_GetSerialNumberString(dev->device_handle, string, 2 * maxlen);
    if (!res) {
        register_error(dev, "HidD_GetSerialNumberString");
        return -1;
    }

    return 0;
}

int HID_API_EXPORT_CALL HID_API_CALL hid_get_indexed_string(hid_device *dev, int string_index, wchar_t *string, size_t maxlen)
{
    BOOL res;

    res = HidD_GetIndexedString(dev->device_handle, string_index, string, 2 * maxlen);
    if (!res) {
        register_error(dev, "HidD_GetIndexedString");
        return -1;
    }

    return 0;
}


HID_API_EXPORT const wchar_t * HID_API_CALL  hid_error(hid_device *dev)
{
    return (wchar_t*)dev->last_error_str;
}


//#define PICPGM
//#define S11
#define P32
#ifdef S11
  unsigned short VendorID = 0xa0a0;
    unsigned short ProductID = 0x0001;
#endif

#ifdef P32
  unsigned short VendorID = 0x04d8;
    unsigned short ProductID = 0x3f;
#endif


#ifdef PICPGM
  unsigned short VendorID = 0x04d8;
  unsigned short ProductID = 0x0033;
#endif


#if 0
int __cdecl main(int argc, char* argv[])
{
    int res;
    unsigned char buf[65];

    UNREFERENCED_PARAMETER(argc);
    UNREFERENCED_PARAMETER(argv);

    // Set up the command buffer.
    memset(buf,0x00,sizeof(buf));
    buf[0] = 0;
    buf[1] = 0x81;


    // Open the device.
    int handle = open(VendorID, ProductID, L"12345");
    if (handle < 0)
        printf("unable to open device\n");


    // Toggle LED (cmd 0x80)
    buf[1] = 0x80;
    res = write(handle, buf, 65);
    if (res < 0)
        printf("Unable to write()\n");

    // Request state (cmd 0x81)
    buf[1] = 0x81;
    write(handle, buf, 65);
    if (res < 0)
        printf("Unable to write() (2)\n");

    // Read requested state
    read(handle, buf, 65);
    if (res < 0)
        printf("Unable to read()\n");

    // Print out the returned buffer.
    for (int i = 0; i < 4; i++)
        printf("buf[%d]: %d\n", i, buf[i]);

    return 0;
}
#endif

touch_package *getPackage(unsigned char masterCmd, unsigned char subCmd,
                                        unsigned char dataLength, unsigned char *data)
{
    touch_package *package = (touch_package*)malloc(sizeof(touch_package));
    memset(package, 0, sizeof(touch_package));
    package->master_cmd = masterCmd;
    package->sub_cmd = subCmd;
    package->data_length = dataLength;
    if (data != NULL) {
        memcpy(package->data, data, dataLength);
    }
    return package;
}
void putPackage(touch_package *package) { if (package) free(package);}

/*
#ifdef __cplusplus
} // extern "C"
#endif
*/
