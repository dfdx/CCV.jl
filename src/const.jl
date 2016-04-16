

# modifier for converting to gray-scale
const CCV_IO_GRAY      = 0x100
# modifier for converting to color
const CCV_IO_RGB_COLOR = 0x300

# modifier for not copy the data over when read raw in-memory data
const CCV_IO_NO_COPY = 0x10000

# read self-describe in-memory data
const CCV_IO_ANY_STREAM     = 0x010
const CCV_IO_BMP_STREAM     = 0x011
const CCV_IO_JPEG_STREAM    = 0x012
const CCV_IO_PNG_STREAM     = 0x013
const CCV_IO_PLAIN_STREAM   = 0x014
const CCV_IO_DEFLATE_STREAM = 0x015
# read self-describe on-disk data
const CCV_IO_ANY_FILE       = 0x020
const CCV_IO_BMP_FILE       = 0x021
const CCV_IO_JPEG_FILE      = 0x022
const CCV_IO_PNG_FILE       = 0x023
const CCV_IO_BINARY_FILE    = 0x024
# read not-self-describe in-memory data (a.k.a. raw data)
# you need to specify rows cols or scanline for these data
const CCV_IO_ANY_RAW        = 0x040
const CCV_IO_RGB_RAW        = 0x041
const CCV_IO_RGBA_RAW       = 0x042
const CCV_IO_ARGB_RAW       = 0x043
const CCV_IO_BGR_RAW        = 0x044
const CCV_IO_BGRA_RAW       = 0x045
const CCV_IO_ABGR_RAW       = 0x046
const CCV_IO_GRAY_RAW       = 0x047

const CCV_IO_FINAL = 0x00
const CCV_IO_CONTINUE = 0x01
const CCV_IO_ERROR = 0x02
const CCV_IO_ATTEMPTED = 0x03
const CCV_IO_UNKNOWN = 0x04


const CCV_8U  = 0x01000
const CCV_32S = 0x02000
const CCV_32F = 0x04000
const CCV_64S = 0x08000
const CCV_64F = 0x10000
