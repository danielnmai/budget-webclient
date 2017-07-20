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



jQuery( document ).ready(function( $ ) {

  $("#input_location").geocomplete();
  var $form = $( "#landing_form" );
  var $input = $form.find( "#income_input" );
  // Initialization
  $input.autoNumeric('init', { currencySymbol : '$', mDec: '0' });
});

function sortObject(o) {
    return Object.keys(o).sort().reduce((r, k) => (r[k] = o[k], r), {});
}

function loadBarChart(category_names, category_percent) {

  var cat_hash = {};
  for (i = 0; i < category_names.length; i++) {
      cat_hash[category_percent[i]] = category_names[i];
  }
 
  cat_percent = Object.keys(cat_hash);
  cat_names = cat_percent.map(function(v) { return cat_hash[v]; });

  var ctx = document.getElementById('barChart').getContext('2d');
  var myChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: cat_names,
      datasets: [{
        label: 'Category Percent',
        data: cat_percent,
        backgroundColor: "rgba(153,255,51,0.4)"
      }]
    }
  });
}
function loadLineChart(cat_hash){
  console.log(cat_hash);
 
  cat_names = Object.keys(cat_hash);
  cat_percent = cat_names.map(function(v) { return cat_hash[v]; });

  var colors = [];

  for (i = 0; i < cat_percent.length; i++) {
      colors[i] = '#'+Math.floor(Math.random()*16777215).toString(16);
  }

 var ctx = document.getElementById("lineChart").getContext('2d');
 var myChart = new Chart(ctx, {
   type: 'line',
   data: {
     labels: cat_names,
     datasets: [{
        label: 'Frequency of Transactions',
       backgroundColor: "rgba(153,255,51,0.4)",
       data: cat_percent
     }]
   }
 });

};

function loadPieChart(category_names, category_percent) {

  var cat_hash = {};
  for (i = 0; i < category_names.length; i++) {
      cat_hash[category_percent[i]] = category_names[i];
  }
  
  cat_percent = Object.keys(cat_hash);
  cat_names = cat_percent.map(function(v) { return cat_hash[v]; });
  var colors = [];

  for (i = 0; i < cat_percent.length; i++) {
      colors[i] = '#'+Math.floor(Math.random()*16777215).toString(16);
  }

  var ctx = document.getElementById("pieChart").getContext('2d');
  var myChart = new Chart(ctx, {
    type: 'pie',
    data: {
      labels: cat_names,
      datasets: [{
        backgroundColor: colors,
        data: cat_percent
      }]
    }
  });
}


function loadDoughnutChart(cat_hash){

  cat_names = Object.keys(cat_hash);
  cat_names.replace(/[[\]]/g,'');
  cat_percent = cat_names.map(function(v) { return cat_hash[v]; });
  
  var colors = [];

  for (i = 0; i < cat_percent.length; i++) {
      colors[i] = '#'+Math.floor(Math.random()*16777215).toString(16);
  }

  var ctx = document.getElementById("doughnutChart").getContext('2d');
  var myChart = new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: cat_names,
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
        data: cat_percent
      }]
    }
  });









}







