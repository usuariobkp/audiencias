class audiencias.views.DependenciesTree extends Backbone.View
  id: 'dependencies'
  containerTemplate: JST["backbone/templates/admin/dependencies/list_container"]
  treeTemplate: JST["backbone/templates/admin/dependencies/tree"]
  resultsTemplate: JST["backbone/templates/admin/dependencies/search_results"]
  events: 
    'click #dependencies-tree .dependency': 'selectDependency'
    'click #dependencies-results .dependency': 'selectDependency'
    'click #dependencies-tree .new-dependency': 'newDependency'
  
  initialize: ->
    $(window).on('search:show-full-list', @showFullList)
      .on('search:show-results-list', @showResultsList)
    audiencias.globals.userDependencies.on('audiences:loaded', =>
      @render()
      audiencias.globals.userDependencies.on('change add remove', @render)
    )
    audiencias.globals.users.on('users:loaded', =>
      @toggleAddDependencyButton()
      audiencias.globals.users.on('change add', @toggleAddDependencyButton)
    )
    @mode = 'tree'

  render: =>
    scrollPosition = if @$el.find('.nano-content').length > 0 then @$el.find('.nano-content').scrollTop() else 0
    @$el.html(@containerTemplate(mode: @mode))
    if @mode == 'tree'
      dependenciesTree = @treeTemplate({
        nodes: audiencias.globals.userDependencies.filter( (d) -> d.get('top') or not d.get('parent_id') ),
        padding: 12.5,
        template: @treeTemplate
      })
      @$el.find('#dependencies-tree').append(dependenciesTree)
    else
      resultsEl = @resultsTemplate({ 
        results: @results, 
      })
      @$el.find('#dependencies-results').html(resultsEl)
    @$el.find('.list-container').nanoScroller(flash: false, scrollTop: scrollPosition)

  selectDependency: (event) =>
    id = $(event.currentTarget).data('dependency-id')
    audiencias.globals.userDependencies.setSelected(id)
    $(window).trigger('dependency-selected', [id])

  showFullList: =>
    @mode = 'tree'
    @render()

  showResultsList: (e, results) =>
    @mode = 'results'
    resultsIds = _.collect(results, (r) -> r.ref )
    @results = audiencias.globals.userDependencies.filter((d) -> 
      resultsIds.indexOf(d.get('id')) > -1 
    )
    @render()

  newDependency: =>
    $(window).trigger('add-new-dependency')

  toggleAddDependencyButton: =>
    currentUser = audiencias.globals.users.currentUser()
    if currentUser and currentUser.get('role') == 'superadmin'
      @$el.find('.new-dependency').removeClass('hidden')