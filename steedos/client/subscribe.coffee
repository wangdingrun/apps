Meteor.startup ->

    Steedos.users_add_email = ()->
        swal
            title: t("primary_email_needed"),
            text: t("primary_email_needed_description"),
            type: 'input',
            showCancelButton: false,
            closeOnConfirm: false,
            animation: "slide-from-top"
        , (inputValue) ->
            console.log("You wrote", inputValue);
            Meteor.call "users_add_email", inputValue, (error, result)->
                if result?.error
                    toastr.error result.message
                else
                    swal t("primary_email_updated"), "", "success"


    Meteor.subscribe "userData", ()->
        if Meteor.user()
            primaryEmail = Meteor.user().emails?[0]?.address
            if !primaryEmail
                Steedos.users_add_email();