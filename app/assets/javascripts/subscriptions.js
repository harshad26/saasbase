var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

jQuery(function ($) {

    $("#monthly-plan-1").click(function(){
        $("#current_plan").val("2").change()
    });

    $("#monthly-plan-2").click(function(){
        $("#current_plan").val("3").change()
    });

    $("#monthly-plan-3").click(function(){
        $("#current_plan").val("4").change()
    });

    $("#yearly-plan-1").click(function(){
        $("#current_plan").val("5").change()
    });

    $("#yearly-plan-2").click(function(){
        $("#current_plan").val("6").change()
    });

    $("#yearly-plan-3").click(function(){
        $("#current_plan").val("7").change()
    });

    $('.payment-errors-alert').hide();

    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));

    var stripeResponseHandler = function (status, response) {
        var $form = $('#new_user');

        if (response.error) {
            // Show the errors on the form
            $('.payment-errors-alert').show();
            $form.find('.payment-errors').text(response.error.message);
            $form.find('button').prop('disabled', false);
        } else {
            // token contains id, last4, and card type
            var token = response.id;
            // Insert the token into the form so it gets submitted to the server
            $form.append($('<input type="hidden" name="stripe_token" />').val(token));
            $form.append($('<input type="hidden" name="plan_id" />').val(getUrlParameter("plan_id")));

            // and re-submit
            $form.get(0).submit();
        }
    };

    $('#new_user').submit(function (e) {
        if ($('input[data-stripe="number"]').length != 0) {
            var $form = $(this);

            // Disable the submit button to prevent repeated clicks
            $form.find('button').prop('disabled', true);

            Stripe.card.createToken($form, stripeResponseHandler);
        }
        // Prevent the form from submitting with the default action
        return false;
    });


});