// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

//= require select2
//= require moment 
//= require fullcalendar
//= require fullcalendar/locale-all


import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "../js/sb-admin-2"
import "../js/sb-admin-2.min"
import "../vendor/jquery-easing/jquery.easing.min"
import "../vendor/bootstrap/js/bootstrap.bundle.min"
import "../vendor/jquery/jquery.min"
import "../stylesheets/application"
import "@fortawesome/fontawesome-free/css/all"
import 'controllers'

Rails.start()
Turbolinks.start()
ActiveStorage.start()
require("channels")
require("jquery")

globalThis.toastr = require("toastr")

toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": false,
  "progressBar": false,
  "positionClass": "toast-top-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "3000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}
