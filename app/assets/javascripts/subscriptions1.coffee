# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "click", "#monthly-plan-1", -> $("#current_plan").val("2").change()
$(document).on "click", "#monthly-plan-2", -> $("#current_plan").val("3").change()
$(document).on "click", "#monthly-plan-3", -> $("#current_plan").val("4").change()

$(document).on "click", "#yearly-plan-1", -> $("#current_plan").val("5").change()
$(document).on "click", "#yearly-plan-2", -> $("#current_plan").val("6").change()
$(document).on "click", "#yearly-plan-3", -> $("#current_plan").val("7").change()

subscription = undefined
jQuery ->
  Stripe.setPublishableKey $('meta[name="stripe-key"]').attr('content')
  subscription.setUpForm()
subscription =
  setUpForm: ->
    $('.update_subscriber').submit ->
      $('input[type="submit"]').attr 'disabled', true
      if $('#card_number').length
        subscription.updateCard()
        false
      else
        true
  updateCard: ->
    card = undefined
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken card, subscription.handleStripeResponse
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#subscriber_stripe_card_token').val response.id
      $('.update_subscriber')[0].submit()
    else
      $('#stripe_error').text response.error.message
      $('input[type="submit"]').attr 'disabled', false
