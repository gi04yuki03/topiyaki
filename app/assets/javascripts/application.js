//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require cocoon

$(document).on ("turbolinks:load", function() {
  $('.drawer').drawer();
  $('.drawer-nav').on('click', function() {
    $('.drawer').drawer('close');
  });
});

$(function(){
  setTimeout("$('.notice').fadeOut('slow')", 1000);
});



$(document).on('turbolinks:load', function() {
  const addButton = $('.procedure-section .add-btn');
  const maxForms = 5;

  addButton.on('click', function(e) {
    e.preventDefault();
    const formCount = $('.procedure-fields').length;
    if (formCount >= maxForms) {
      alert('これ以上作り方の追加はできません');
      const newFormCount = $('.procedure-fields').length;
      if (newFormCount >= maxForms) { 
        $('.procedure-fields').first().remove();
        return;
      }
    }
    $('.procedure-section').append($('.procedure-fields-template').html());
  });

  $(document).on('click', '.remove-btn', function(e) {
    e.preventDefault();
    $(this).closest('.nested-fields').remove();
    const formCount = $('.procedure-fields').length;
    if (formCount < maxForms) {
      addButton.prop('disabled', false);
    }
  });
});
