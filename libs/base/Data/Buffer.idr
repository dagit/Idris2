module Data.Buffer

import Data.List

%default total

-- Reading and writing binary buffers. Note that this primitives are unsafe,
-- in that they don't check that buffer locations are within bounds.
-- We really need a safe wrapper!
-- They are used in the Idris compiler itself for reading/writing checked
-- files.

-- This is known to the compiler, so maybe ought to be moved to Builtin
export
data Buffer : Type where [external]

%foreign "scheme:blodwen-buffer-size"
         "RefC:getBufferSize"
         "node:lambda:b => b.length"
prim__bufferSize : Buffer -> Int

export %inline
rawSize : HasIO io => Buffer -> io Int
rawSize buf = pure (prim__bufferSize buf)

%foreign "scheme:blodwen-new-buffer"
         "RefC:newBuffer"
         "node:lambda:s=>Buffer.alloc(s)"
prim__newBuffer : Int -> PrimIO Buffer

export
newBuffer : HasIO io => Int -> io (Maybe Buffer)
newBuffer size
    = if size >= 0
            then do buf <- primIO (prim__newBuffer size)
                    pure $ Just buf
                 else pure Nothing
--          if prim__nullAnyPtr buf /= 0
--             then pure Nothing
--             else pure $ Just $ MkBuffer buf size 0

%foreign "scheme:blodwen-buffer-setbyte"
         "RefC:setBufferByte"
         "node:lambda:(buf,offset,value)=>buf.writeUInt8(value, offset)"
prim__setByte : Buffer -> (offset : Int) -> (val : Int) -> PrimIO ()

%foreign "scheme:blodwen-buffer-setbyte"
         "RefC:setBufferByte"
         "node:lambda:(buf,offset,value)=>buf.writeUInt8(value, offset)"
prim__setBits8 : Buffer -> (offset : Int) -> (val: Bits8) -> PrimIO ()

-- Assumes val is in the range 0-255
export %inline
setByte : HasIO io => Buffer -> (offset : Int) -> (val : Int) -> io ()
setByte buf offset val
    = primIO (prim__setByte buf offset val)

export %inline
setBits8 : HasIO io => Buffer -> (offset : Int) -> (val : Bits8) -> io ()
setBits8 buf offset val
    = primIO (prim__setBits8 buf offset val)

%foreign "scheme:blodwen-buffer-getbyte"
         "RefC:getBufferByte"
         "node:lambda:(buf,offset)=>buf.readUInt8(offset)"
prim__getByte : Buffer -> (offset : Int) -> PrimIO Int

%foreign "scheme:blodwen-buffer-getbyte"
         "RefC:getBufferByte"
         "node:lambda:(buf,offset)=>buf.readUInt8(offset)"
prim__getBits8 : Buffer -> (offset : Int) -> PrimIO Bits8

export %inline
getByte : HasIO io => Buffer -> (offset : Int) -> io Int
getByte buf offset
    = primIO (prim__getByte buf offset)

export %inline
getBits8 : HasIO io => Buffer -> (offset : Int) -> io Bits8
getBits8 buf offset
    = primIO (prim__getBits8 buf offset)

%foreign "scheme:blodwen-buffer-setbits16"
         "node:lambda:(buf,offset,value)=>buf.writeUInt16LE(value, offset)"
prim__setBits16 : Buffer -> (offset : Int) -> (value : Bits16) -> PrimIO ()

export %inline
setBits16 : HasIO io => Buffer -> (offset : Int) -> (val : Bits16) -> io ()
setBits16 buf offset val
    = primIO (prim__setBits16 buf offset val)

%foreign "scheme:blodwen-buffer-getbits16"
         "node:lambda:(buf,offset)=>buf.readUInt16LE(offset)"
prim__getBits16 : Buffer -> (offset : Int) -> PrimIO Bits16

export %inline
getBits16 : HasIO io => Buffer -> (offset : Int) -> io Bits16
getBits16 buf offset
    = primIO (prim__getBits16 buf offset)

%foreign "scheme:blodwen-buffer-setbits32"
         "node:lambda:(buf,offset,value)=>buf.writeUInt32LE(value, offset)"
prim__setBits32 : Buffer -> (offset : Int) -> (value : Bits32) -> PrimIO ()

export %inline
setBits32 : HasIO io => Buffer -> (offset : Int) -> (val : Bits32) -> io ()
setBits32 buf offset val
    = primIO (prim__setBits32 buf offset val)

%foreign "scheme:blodwen-buffer-getbits32"
         "node:lambda:(buf,offset)=>buf.readUInt32LE(offset)"
prim__getBits32 : Buffer -> Int -> PrimIO Bits32

export %inline
getBits32 : HasIO io => Buffer -> (offset : Int) -> io Bits32
getBits32 buf offset
    = primIO (prim__getBits32 buf offset)

%foreign "scheme:blodwen-buffer-setbits64"
prim__setBits64 : Buffer -> Int -> Bits64 -> PrimIO ()

export %inline
setBits64 : HasIO io => Buffer -> (offset : Int) -> (val : Bits64) -> io ()
setBits64 buf offset val
    = primIO (prim__setBits64 buf offset val)

%foreign "scheme:blodwen-buffer-getbits64"
prim__getBits64 : Buffer -> (offset : Int) -> PrimIO Bits64

export %inline
getBits64 : HasIO io => Buffer -> (offset : Int) -> io Bits64
getBits64 buf offset
    = primIO (prim__getBits64 buf offset)

%foreign "scheme:blodwen-buffer-setint32"
         "node:lambda:(buf,offset,value)=>buf.writeInt32LE(value, offset)"
prim__setInt32 : Buffer -> (offset : Int) -> (val : Int) -> PrimIO ()

export %inline
setInt32 : HasIO io => Buffer -> (offset : Int) -> (val : Int) -> io ()
setInt32 buf offset val
    = primIO (prim__setInt32 buf offset val)

%foreign "scheme:blodwen-buffer-getint32"
         "node:lambda:(buf,offset)=>buf.readInt32LE(offset)"
prim__getInt32 : Buffer -> (offset : Int) -> PrimIO Int

export %inline
getInt32 : HasIO io => Buffer -> (offset : Int) -> io Int
getInt32 buf offset
    = primIO (prim__getInt32 buf offset)

%foreign "scheme:blodwen-buffer-setint"
         "RefC:setBufferInt"
         "node:lambda:(buf,offset,value)=>buf.writeInt32LE(value, offset)"
prim__setInt : Buffer -> (offset : Int) -> (val : Int) -> PrimIO ()

export %inline
setInt : HasIO io => Buffer -> (offset : Int) -> (val : Int) -> io ()
setInt buf offset val
    = primIO (prim__setInt buf offset val)

%foreign "scheme:blodwen-buffer-getint"
         "RefC:getBufferInt"
         "node:lambda:(buf,offset)=>buf.readInt32LE(offset)"
prim__getInt : Buffer -> (offset : Int) -> PrimIO Int

export %inline
getInt : HasIO io => Buffer -> (offset : Int) -> io Int
getInt buf offset
    = primIO (prim__getInt buf offset)

%foreign "scheme:blodwen-buffer-setdouble"
         "RefC:setBufferDouble"
         "node:lambda:(buf,offset,value)=>buf.writeDoubleLE(value, offset)"
prim__setDouble : Buffer -> (offset : Int) -> (val : Double) -> PrimIO ()

export %inline
setDouble : HasIO io => Buffer -> (offset : Int) -> (val : Double) -> io ()
setDouble buf offset val
    = primIO (prim__setDouble buf offset val)

%foreign "scheme:blodwen-buffer-getdouble"
         "RefC:getBufferDouble"
         "node:lambda:(buf,offset)=>buf.readDoubleLE(offset)"
prim__getDouble : Buffer -> (offset : Int) -> PrimIO Double

export %inline
getDouble : HasIO io => Buffer -> (offset : Int) -> io Double
getDouble buf offset
    = primIO (prim__getDouble buf offset)

-- Get the length of a string in bytes, rather than characters
export
%foreign "scheme:blodwen-stringbytelen"
         "C:strlen, libc 6"
stringByteLength : String -> Int

%foreign "scheme:blodwen-buffer-setstring"
         "RefC:setBufferString"
         "node:lambda:(buf,offset,value)=>buf.write(value, offset,buf.length - offset, 'utf-8')"
prim__setString : Buffer -> (offset : Int) -> (val : String) -> PrimIO ()

export %inline
setString : HasIO io => Buffer -> (offset : Int) -> (val : String) -> io ()
setString buf offset val
    = primIO (prim__setString buf offset val)

%foreign "scheme:blodwen-buffer-getstring"
         "RefC:getBufferString"
         "node:lambda:(buf,offset,len)=>buf.slice(offset, offset+len).toString('utf-8')"
prim__getString : Buffer -> (offset : Int) -> (len : Int) -> PrimIO String

export %inline
getString : HasIO io => Buffer -> (offset : Int) -> (len : Int) -> io String
getString buf offset len
    = primIO (prim__getString buf offset len)

export
covering
bufferData : HasIO io => Buffer -> io (List Int)
bufferData buf
    = do len <- rawSize buf
         unpackTo [] len
  where
    covering
    unpackTo : List Int -> Int -> io (List Int)
    unpackTo acc 0 = pure acc
    unpackTo acc offset
        = do val <- getByte buf (offset - 1)
             unpackTo (val :: acc) (offset - 1)


%foreign "scheme:blodwen-buffer-copydata"
         "RefC:copyBuffer"
         "node:lambda:(b1,o1,length,b2,o2)=>b1.copy(b2,o2,o1,o1+length)"
prim__copyData : (src : Buffer) -> (srcOffset, len : Int) ->
                 (dst : Buffer) -> (dstOffset : Int) -> PrimIO ()

export
copyData : HasIO io => Buffer -> (srcOffset, len : Int) ->
           (dst : Buffer) -> (dstOffset : Int) -> io ()
copyData src start len dest offset
    = primIO (prim__copyData src start len dest offset)

export
resizeBuffer : HasIO io => Buffer -> Int -> io (Maybe Buffer)
resizeBuffer old newsize
    = do Just buf <- newBuffer newsize
              | Nothing => pure Nothing
         -- If the new buffer is smaller than the old one, just copy what
         -- fits
         oldsize <- rawSize old
         let len = if newsize < oldsize then newsize else oldsize
         copyData old 0 len buf 0
         pure (Just buf)

||| Create a buffer containing the concatenated content from a
||| list of buffers.
export
concatBuffers : HasIO io => List Buffer -> io (Maybe Buffer)
concatBuffers xs
    = do let sizes = map prim__bufferSize xs
         let (totalSize, revCumulative) = foldl scanSize (0,[]) sizes
         let cumulative = reverse revCumulative
         Just buf <- newBuffer totalSize
              | Nothing => pure Nothing
         traverse_ (\(b, size, watermark) => copyData b 0 size buf watermark) (zip3 xs sizes cumulative)
         pure (Just buf)
    where
        scanSize : (Int, List Int) -> Int -> (Int, List Int)
        scanSize (s, cs) x  = (s+x, s::cs)

||| Split a buffer into two at a position.
export
splitBuffer : HasIO io => Buffer -> Int -> io (Maybe (Buffer, Buffer))
splitBuffer buf pos = do size <- rawSize buf
                         if pos > 0 && pos < size
                             then do Just first <- newBuffer pos
                                        | Nothing => pure Nothing
                                     Just second <- newBuffer (size - pos)
                                        | Nothing => pure Nothing
                                     copyData buf 0 pos first 0
                                     copyData buf pos (size-pos) second 0
                                     pure $ Just (first, second)
                             else pure Nothing
