// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require angular
//= require app
//= require geocomplete
//= require Chart.min
//= require autonumeric
//= require_tree .

$(function() {
  $("#location_input").geocomplete();

  var $form = $( "#landing_form" );
  var $input = $form.find( "#income_input" );
  // Initialization
  $input.autoNumeric('init', { currencySymbol : '$', mDec: '0' });
});


function loadBarChart(category_names, category_percent) {
  var ctx = document.getElementById('barChart').getContext('2d');
  var myChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: category_names,
      datasets: [{
        label: 'Category Percent',
        data: category_percent,
        backgroundColor: "rgba(153,255,51,0.4)"
      }]
    }
  });
}

function loadPieChart(category_names, category_percent) {
  var ctx = document.getElementById("pieChart").getContext('2d');
  var myChart = new Chart(ctx, {
    type: 'pie',
    data: {
      labels: category_names,
      datasets: [{
        backgroundColor: [
        "#2ecc71",
        "#3498db",
        "#95a5a6",
        "#9b59b6",
        "#f1c40f",
        "#e74c3c",
        "#34495e"
        ],
        data: category_percent
      }]
    }
  });
}