
url = (if window.URL then window.URL else window.webkitURL)

Template.main.rendered = () ->
  Session.set('original', null)
  Session.set('processed', null)

Template.main.events
  'change input[type=file]': (e,t) ->
    file = e.target.files[0]
    Session.set 'original', url.createObjectURL(file)
    
    processImage file, 500, 500, (data) ->
      Session.set('processed', data)

Template.main.helpers
  original: () ->
    Session.get 'original'
  processed: () ->
    Session.get 'processed'