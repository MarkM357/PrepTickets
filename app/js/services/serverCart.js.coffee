ServerCartService = @prepTickets.factory('ServerCartService', ($q, $rootScope, $cookieStore) ->
  _cart = {}
  _clientCart = {}
  _storeKey = null
  _uploadItems = 0
  initCart: (storeKey) ->
    def = $q.defer()
    BWL.Services.Cart.GetCart storeKey, 
      (cart) ->
        $rootScope.$apply ->
          @_cart = cart
          def.resolve(cart)
      (err) ->
        $rootScope.$apply ->
          def.reject(err)
    def.promise

  clearCart: (storeKey) ->
    def = $q.defer()
    BWL.Services.Cart.ClearCart storeKey, 
      (cart) ->
        _cart = {}
        $rootScope.$apply(def.resolve(cart))
      (err) ->
        $rootScope.$apply(def.reject(err))
    def.promise

  upload: (cart) ->
    _storeKey = cart.StoreKey
    _clientCart = cart
    @sendNextItem()

  finish: ->
    $rootScope.$broadcast("ServerCart:Uploaded")
    true
  sendNextItem: ->
    return false unless _clientCart?
    nextItem = null
    for key, item of _clientCart?.Items
      if not item.uploaded
        nextItem = item 

    if nextItem
      @addItem(_storeKey, nextItem.Key, nextItem.Type, nextItem.Quantity).then(
        (success) =>
          if success
            _clientCart.Items[nextItem.Key].uploaded = true
            @sendNextItem()
        (err) ->
          $rootScope.error.log err
      )
    else
      return @finish()

    null
      

  addItem: (storeKey, itemKey, itemType, quantity) ->
    def = $q.defer()
    BWL.Services.Cart.AddItems(
      storeKey
      itemType
      itemKey
      quantity
      null
      (success) ->
        $rootScope.$apply(def.resolve(success))
      (err) ->
        $rootScope.$apply(def.reject(err))
    )
    
    return def.promise

)

ServerCartService.$inject = ["$q", "$rootScope", "$cookieStore"]