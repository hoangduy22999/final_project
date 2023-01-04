// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "../js/sb-admin-2"
import "../js/sb-admin-2.min"
// import "../js/demo/chart-area-demo"
// import "../js/demo/chart-bar-demo"
// import "../js/demo/chart-pie-demo"
// import "../js/demo/datatables-demo"
import "../vendor/chart.js/Chart.min"
import "../vendor/jquery-easing/jquery.easing.min"
import "../vendor/bootstrap/js/bootstrap.bundle.min"
import "../vendor/jquery/jquery.min"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
require("channels")
require("jquery")
