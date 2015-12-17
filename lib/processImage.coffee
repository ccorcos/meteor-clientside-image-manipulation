
# processImage = (imageFile, maxWidth, maxHeight, callback) ->
processImage = (imageFile, rest...) ->
  callback = rest[rest.length-1]
  if not _.isFunction(callback) then console.log "ERROR: you need to pass a callback function to processImage"

  maxHeight = undefined
  maxWidth = undefined
  quality = undefined

  if rest.length is 3 or 4
    maxWidth = rest[0]
    maxHeight = rest[1]
    if rest.length is 4
      quality = rest[2]


  canvas = document.createElement('canvas')
  ctx = canvas.getContext("2d")

  img = new Image()
  url = (if window.URL then window.URL else window.webkitURL)
  img.src = url.createObjectURL(imageFile)

  # draw on the canvas
  img.onload = (e) ->
    url.revokeObjectURL @src
    width = undefined
    height = undefined
    binaryReader = new FileReader()

    binaryReader.onloadend = (d) ->
      exif = undefined
      transform = "none"
      # exif = EXIF.readFromBinaryFile(createBinaryFile(d.target.result))
      exif = EXIF.readFromBinaryFile(d.target.result)

      if exif.Orientation is 1
        width = img.width
        height = img.height
        transform = ""
      else if exif.Orientation is 2
        width = img.width
        height = img.height
        transform = "RotateNoneFlipX"
      else if exif.Orientation is 3
        width = img.width
        height = img.height
        transform = "Rotate180FlipNone"
      else if exif.Orientation is 4
        width = img.width
        height = img.height
        transform = "Rotate180FlipX"
      else if exif.Orientation is 5
        width = img.height
        height = img.width
        transform = "Rotate90FlipX"
      else if exif.Orientation is 6
        width = img.height
        height = img.width
        transform = "Rotate90FlipNone"
      else if exif.Orientation is 7
        width = img.height
        height = img.width
        transform = "Rotate270FlipX"
      else if exif.Orientation is 8
        width = img.height
        height = img.width
        transform = "Rotate270FlipNone"
      else
        width = img.width
        height = img.height
        transform = ""

      if maxWidth and maxHeight
        if width / maxWidth > height / maxHeight
          if width > maxWidth
            height *= maxWidth / width
            width = maxWidth
        else
          if height > maxHeight
            width *= maxHeight / height
            height = maxHeight

      canvas.width = width
      canvas.height = height
      ctx.fillStyle = "white"
      ctx.fillRect 0, 0, canvas.width, canvas.height

      if transform is "RotateNoneFlipX" #2
        ctx.setTransform -1, 0, 0, 1, width, 0
        ctx.drawImage img, 0, 0, width, height
      else if transform is "Rotate180FlipNone" #3
        ctx.setTransform -1, 0, 0, -1, width, height
        ctx.drawImage img, 0, 0, width, height
      else if transform is "Rotate180FlipX" #4
        ctx.setTransform 1, 0, 0, -1, 0, height
        ctx.drawImage img, 0, 0, width, height
      else if transform is "Rotate90FlipX" #5
        ctx.setTransform 0, 1, 1, 0, 0, 0
        ctx.drawImage img, 0, 0, height, width
      else if transform is "Rotate90FlipNone" #6
        ctx.setTransform 0, 1, -1, 0, width, 0
        ctx.drawImage img, 0, 0, height, width
      else if transform is "Rotate270FlipX" #7
        ctx.setTransform 0, -1, -1, 0, width, height
        ctx.drawImage img, 0, 0, height, width
      else if transform is "Rotate270FlipNone" #8
        ctx.setTransform 0, -1, 1, 0, 0, height
        ctx.drawImage img, 0, 0, height, width
      else
        ctx.setTransform 1, 0, 0, 1, 0, 0
        ctx.drawImage img, 0, 0, width, height

      ctx.setTransform 1, 0, 0, 1, 0, 0

      # process into an image
      pixels = ctx.getImageData(0, 0, canvas.width, canvas.height)

      # filter out the greenscreen!
      # r = undefined
      # g = undefined
      # b = undefined
      # i = undefined
      # py = 0

      # for py in [0...pixels.height]
      #   for px in [0...pixels.width]
      #     i = (py * pixels.width + px) * 4
      #     r = pixels.data[i]
      #     g = pixels.data[i + 1]
      #     b = pixels.data[i + 2]
      #     pixels.data[i + 3] = 0  if g > 100 and g > r * 1.35 and g > b * 1.6

      ctx.putImageData pixels, 0, 0

      if quality
      	data = canvas.toDataURL("image/jpeg", quality)
      else
        data = canvas.toDataURL("image/jpeg")

      callback(data)

    binaryReader.readAsArrayBuffer imageFile
