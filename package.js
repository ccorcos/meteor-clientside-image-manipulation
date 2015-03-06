Package.describe({
  name: 'ccorcos:clientside-image-manipulation',
  summary: 'A clientside javascript library for manipulating images before uploading.',
  version: '1.0.3',
  git: 'https://github.com/ccorcos/meteor-clientside-image-manipulation.git'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');

  api.use(['coffeescript', 'underscore'], 'client')

  api.addFiles(['lib/binaryFile.js', 'lib/exif.js', 'lib/processImage.coffee'], 'client');

  api.export('processImage', ['client'])

});
