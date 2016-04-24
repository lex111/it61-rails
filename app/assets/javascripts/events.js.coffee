@Styx.Initializers.Events =
  index: ->
    $ ->
      setupPagination()
      $('.page-header > .actions > a').tooltip()
  new: ->
    $ ->
      It61.Lib.MarkdownEditor.setupEditors()
  create: ->
    $ ->
      It61.Lib.MarkdownEditor.setupEditors()
  edit: ->
    $ ->
      It61.Lib.MarkdownEditor.setupEditors()
  update: ->
    $ ->
      It61.Lib.MarkdownEditor.setupEditors()
