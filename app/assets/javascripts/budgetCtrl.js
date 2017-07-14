function addCategory() {
  var parent = document.getElementById('form');

  var div_1 = document.createElement('div');
  var label_name = document.createElement('label');
  var text = document.createTextNode("Category Name:");
  label_name.appendChild(text);

  var input_name = document.createElement('input');
  input_name.type = "text";
  input_name.name = "cat_names[]";
  div_1.appendChild(label_name);
  div_1.appendChild(input_name);

  var div_2 = document.createElement('div');
  var label_percent = document.createElement('label');
  var text = document.createTextNode("Category Percent:");
  label_percent.appendChild(text); 

  var input_percent = document.createElement('input');
  input_percent.type = "text";  
  input_percent.name = "cat_percent[]";
  div_2.appendChild(label_percent);
  div_2.appendChild(input_percent);

  parent.appendChild(div_1);
  parent.appendChild(div_2);
 

} 