class audiencias.views.Facets extends Backbone.View
  template: JST["backbone/templates/search/facet"]
  representationTemplate: JST["backbone/templates/search/facet_representation"]
  className: 'facets'
  events: 
    'click .expand-facet-list': 'expandFacetList'
    'click .collapse-facet-list': 'collapseFacetList'
    'click .facet-group-name': 'toggleFacetGroup'

  initialize: (options) ->
    @linkCreator = options.linkCreator

  render: ->
    aggregations = audiencias.globals.results.aggregations || {}
    selected = audiencias.globals.results.selected_values || {}

    @$el.append(@template(
      title: 'Personas'
      selectedValue: selected['person'],
      paramName: 'persona',
      facetList: aggregations['_people']
      linkCreator: @linkCreator
    ))

    @$el.append(@template(
      title: 'Poder Ejecutivo Nacional'
      selectedValue: selected['dependency'],
      paramName: 'pen',
      facetList: aggregations['_dependency']
      linkCreator: @linkCreator
    ))

    @$el.append(@representationTemplate(
      title: 'En representación'
      aggregations: [{ 
        facetList: aggregations['_represented_organism'], 
        selected: selected['organism'], 
        paramName: 'organismo-estatal',
        name: 'Organismo Estatal'
      }, { 
        facetList: aggregations['_represented_group'], 
        selected: selected['group'], 
        paramName: 'grupo-de-personas',
        name: 'Grupo de personas'
      }, { 
        facetList: aggregations['_represented_entity'], 
        selected: selected['entity'], 
        paramName: 'persona-juridica',
        name: 'Personas Jurídicas'
      }],
      linkCreator: @linkCreator
    ))

    @$el.append(@template(
      title: 'Interes Invocado'
      selectedValue: selected['interest_invoked'],
      paramName: 'interes-invocado',
      facetList: aggregations['_interest_invoked']
      linkCreator: @linkCreator
    ))
    
  expandFacetList: (e) =>
    target = $(e.currentTarget)
    facetList = target.siblings('.facet-list.hidden')
    facetList.first().removeClass('hidden')
    if facetList.length == 1
      target.addClass('hidden')
      target.siblings('.collapse-facet-list').removeClass('hidden')

  collapseFacetList: (e) =>
    target = $(e.currentTarget).addClass('hidden')
    target.siblings('.expand-facet-list').removeClass('hidden')
    facetList = target.siblings('.facet-list')
    facetList.addClass('hidden')
    facetList.first().removeClass('hidden')

  toggleFacetGroup: (e) =>
    target = $(e.currentTarget)
    target.find('i').toggleClass('hidden')
    target.siblings('.facet-group').toggleClass('hidden')