#= require_self
#= require_tree ./templates
#= require_tree ./views

window.Audiencias =
  Views: {}
  App: {
    UserLogin: ->
      header = new Audiencias.Views.Header
      header.render()
      $('body').prepend(header.el)

      userLogin = new Audiencias.Views.UserLogin
      userLogin.render()
      $('body').append(userLogin.el)

    SendPasswordReset: ->
      header = new Audiencias.Views.Header
      header.render()
      $('body').prepend(header.el)

      passwordReset = new Audiencias.Views.PasswordReset
      passwordReset.render()
      $('body').append(passwordReset.el)
  }
