BinaryFile = function(data, dataOffset, dataLength) {
  var dataOffset = dataOffset || 0;
  var dataLength = 0;

  this.getRawData = function() {
    return data;
  }

  if (typeof data == "string") {
    dataLength = dataLength || data.length;

    this.getByteAt = function(offset) {
      return data.charCodeAt(offset + dataOffset) & 0xFF;
    }
  } else if (typeof data == "unknown") {
    dataLength = dataLength || IEBinary_getLength(data);

    this.getByteAt = function(offset) {
      return IEBinary_getByteAt(data, offset + dataOffset);
    }
  } else {

  }

  this.getLength = function() {
    return dataLength;
  }

  this.getSByteAt = function(offset) {
    var byte = this.getByteAt(offset);
    if (byte > 127)
      return byte - 256;
    else
      return byte;
  }

  this.getShortAt = function(offset, bigEndian) {
    var short = bigEndian ? 
      (this.getByteAt(offset) << 8) + this.getByteAt(offset + 1)
      : (this.getByteAt(offset + 1) << 8) + this.getByteAt(offset)
    if (short < 0) short += 65536;
    return short;
  }
  this.getSShortAt = function(offset, bigEndian) {
    var ushort = this.getShortAt(offset, bigEndian);
    if (ushort > 32767)
      return ushort - 65536;
    else
      return ushort;
  }
  this.getLongAt = function(offset, bigEndian) {
    var byte1 = this.getByteAt(offset),
      byte2 = this.getByteAt(offset + 1),
      byte3 = this.getByteAt(offset + 2),
      byte4 = this.getByteAt(offset + 3);

    var long = bigEndian ? 
      (((((byte1 << 8) + byte2) << 8) + byte3) << 8) + byte4
      : (((((byte4 << 8) + byte3) << 8) + byte2) << 8) + byte1;
    if (long < 0) long += 4294967296;
    return long;
  }
  this.getSLongAt = function(offset, bigEndian) {
    var ulong = this.getLongAt(offset, bigEndian);
    if (ulong > 2147483647)
      return ulong - 4294967296;
    else
      return ulong;
  }
  this.getStringAt = function(offset, length) {
    var chars = [];
    for (var i=offset,j=0;i<offset+length;i++,j++) {
      chars[j] = String.fromCharCode(this.getByteAt(i));
    }
    return chars.join("");
  }

  this.getCharAt = function(offset) {
    return String.fromCharCode(this.getByteAt(offset));
  }
  this.toBase64 = function() {
    return window.btoa(data);
  }
  this.fromBase64 = function(str) {
    data = window.atob(str);
  }
}