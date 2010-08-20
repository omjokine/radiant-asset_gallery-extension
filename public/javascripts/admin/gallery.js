var Asset = {};
var draggable = [];

Event.observe(window, 'load', function() {
  Asset.MakeDraggables();
  Asset.MakeDroppables();
  Asset.SortItems();
  Event.addBehavior({
    '.asset-list-item .delete:click' : function(e) { Asset.DeleteItem($(this).up('.asset-list-item')) }
  });
});

Asset.MakeDraggables = function () { 
  $$('#asset_items .asset-list-item').each(function(element){
    draggable[element.id] = new Draggable(element, { revert: true, ghosting: true });
    element.addClassName('move');
  });
}

Asset.MakeDroppables = function () {
  $$('ul#gallery_items').each(function(box){
    if (!box.hasClassName('droppable')){
      Droppables.add(box, {
        accept: 'move',
        hoverclass: 'hover',
        onDrop: Asset.MoveItem
      });
      box.addClassName('droppable');
    }
  });
}

Asset.MoveItem = function(dragged, dropped, event) {
  new Ajax.Request(urlify($('admin_gallery_items_path').value), {
    method: 'post',
    parameters: {
      'gallery_item[asset_id]' : dragged.id
    },
    onLoading: function() {
      dragged.hide();
      showStatus('Adding Asset to Gallery...');
    },
    onSuccess: function(data) {
      draggable[dragged.id].destroy();
      dragged.removeClassName('move');
      dragged.parentNode.removeChild(dragged);
      dropped.insert({ top: dragged });
      dragged.show();
      hideStatus();
    },
    onFailure: function() {
      // ToDo: How do I reject the drop?
      dragged.show();
      hideStatus();
    }.bind(this)
  });
}

Asset.DeleteItem = function(element) {
  new Ajax.Request(urlify($('admin_gallery_items_path').value, element.id), {
    method: 'delete',
    onLoading: function() {
      element.hide();
      showStatus('Deleting Asset from Gallery...');
    },
    onSuccess: function(data) {
      element.remove();
      hideStatus();
    },
    onFailure: function() {
      element.show();
      hideStatus();
    }.bind(this)
  });
}

Asset.SortItems = function() { 
  Sortable.create('gallery_items', {
    constraint: false,
    overlap: 'horizontal',
    onUpdate: function(element) {
      new Ajax.Request(urlify($('admin_gallery_items_sort_path').value), {
        method: 'put',
        parameters: {
          'items':Sortable.serialize('gallery_items')
        }
      });
      
    }.bind(this)
  });
}

function urlify(route, id) {
  var url = route;
  if ( id !== undefined ) {
    url += '/' + id
  }
  url += '.js?' + new Date().getTime();
  return url;
}
