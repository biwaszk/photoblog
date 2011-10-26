// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Logowanie ----------------------------------------------------------------------------------------
document.observe('dom:loaded', function() {
  $("session_email").observe("focus", function() {
    if (this.getValue()==' email') {
      this.setValue('');
    }
  });
});
document.observe('dom:loaded', function() {
  $("session_email").observe("blur", function() {
    if (this.getValue()=='') {
      this.setValue(' email');
    }
  });
});
document.observe('dom:loaded', function() {
  $("session_password").observe("focus", function() {
    if (this.getValue()==' has\u0142o') {
      this.type="password";
      this.setValue('');
    }
  });
});
document.observe('dom:loaded', function() {
  $("session_password").observe("blur", function() {
    if (this.getValue()=='') {
      this.type="test";
      this.setValue(' has\u0142o');
    }
  });
});

//Szukanie -------------------------------------------------------------------------------------------
document.observe('dom:loaded', function() {
  $("tagi").setValue('SZUKAJ');
  $("tagi").observe("focus", function() {
    if (this.getValue()=='SZUKAJ') {
      this.setValue('');
    }
  });
});
document.observe('dom:loaded', function() {
  $("tagi").observe("blur", function() {
    if (this.getValue()=='') {
      this.setValue('SZUKAJ');
    }
  });
});

// Dodawanie zdjec ---------------------------------------------------------------------------------
document.observe('dom:loaded', function() {
  $("photo_upload").observe("change", function() {
    shortName=this.getValue().match(/[^\/\\]+$/);
    $("fname").setValue(shortName);
  });
});

// Ukrywanie/pokazywanie opisow zdjec ---------------------------------------------------------
document.observe("dom:loaded", function() {
  phd_id=new Array;
  for (i=0; i<$$('div[id^="phd_"]').length; i++) {phd_id[i]=$$('div[id^="phd_"]')[i]['id'];}
  phd_id.each(function(id){$(id).hide();return false;});

  $$('div[id^="oph_"]').invoke('observe', 'click', openPdesc.bind(openPdesc));
  function openPdesc(e){
    var desc=$(e.element()).up('div').firstDescendant().id;
    Effect.toggle(desc, 'slide');
    return false;
  }
});

// Wybor zdjecia do tagowania --------------------------------------------------------------------
document.observe('dom:loaded', function() {
  $("fake_photoL").setValue("  "+$("photo_id").options[ $("photo_id").selectedIndex].text);
  $("photo_id").observe("change", function() {
    val = this.selectedIndex;
    opt = this.options[val].text;
    $("fake_photoL").setValue("  "+opt);
  });
});

// Auto complite -------------------------------------------------------------------------------------
document.observe("dom:loaded", function() {
  new Form.Element.Observer('tagi', 0.5, updateElement);
});

function updateElement() {
  var form_val = $("tagi").getValue();
  if (form_val=='SZUKAJ') {
    $("auto_complite").hide();
    return false;
  }
  else if (form_val=='' || form_val.match(/^[ +]/)) {
    $("auto_complite").fade({duration: 0.3});
    return false;
  }
  else {
    var pars = 'search=' + $("tagi").getValue()

    new Ajax.Request('/lattices/auto_compliter', {
      method: 'get',
      parameters: pars,
      onSuccess: function(request) {
        $("auto_complite").update(request.responseText).appear({duration: 0.3});
      }
    });
  }
}

var current_value = new Array();

//------------------------------------------------------------------------------------------------------



/****************************************************************/

/* Otwieranie zdjec
    document.observe("dom:loaded", function() {
      $$('a[class="save_photo"]').invoke('observe', 'click', openPhoto.bind(openPhoto));
      function openPhoto(e){window.open(e.element(), "_blank");}
    });
*/

/*
 * var element = Event.element(e);  --  *to samo co (')
 * var element = e.element();         --  (')
 * $(Event.element(e))                    --  (')
 * $(e.element());                          --  (')
 * 
 * var elt = Event.findElement(e, 'div'); -- *to samo co ('')
 * var elt = $(e.element()).up('div');    --  ('')
 *  element.ancestors(element)
 *
 * contob = $('up_container').getElementsByClassName('one_phCont');
 *
 */

