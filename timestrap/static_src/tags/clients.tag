<clients>
    <div class="mb-4 clearfix">
        <pager update={ getClients }/>
    </div>

    <div class="row py-1 bg-inverse text-white font-weight-bold rounded-top">
        <div class="col-sm-6">
            Client
        </div>
        <div class="col-sm-2">
            Total Time
        </div>
        <div class="col-sm-2">
            # Related
        </div>
        <div class="col-sm-2">
        </div>
    </div>

    <form name="client-add"
          class="row mb-4 py-2 bg-faded rounded-bottom"
          onsubmit={ submitClient }
          if={ perms && perms.add_client }>
        <div class="col-10">
            <input name="client-name"
                   type="text"
                   class="form-control form-control-sm"
                   ref="name"
                   placeholder="New Client Name"
                   required>
        </div>
        <div class="col-2">
            <button
                    name="client-add-submit"
                    type="submit"
                    class="btn btn-success btn-sm w-100">
                Add
            </button>
        </div>
    </form>

    <client each={ clients } perms={ perms } />


    <script type="es6">
        getClients = function(url) {
            url = (typeof url !== 'undefined') ? url : timestrapConfig.API_URLS.CLIENTS;
            quickFetch(url).then(function(data) {
                this.update({
                    clients: data.results,
                    next: data.next,
                    previous: data.previous
                });
            }.bind(this));
        }.bind(this);


        submitClient = function(e) {
            e.preventDefault();
            toggleButtonBusy(e.target);
            let body = {
                name: this.refs.name.value
            };
            quickFetch(timestrapConfig.API_URLS.CLIENTS, 'post', body).then(function(data) {
                this.refs.name.value = '';
                if (data.id) {
                    this.clients.unshift(data);
                    this.update();
                }
                toggleButtonBusy(e.target);
            }.bind(this));
        }.bind(this);


        getPerms = function() {
            prefetch.PERMISSIONS.then(function(data) {
                let perms = Object;
                $.each(data.results, function(i, perm) {
                    perms[perm.codename] = perm;
                });
                this.perms = perms;
            });
        }.bind(this);

        this.on('mount', function() {
            getPerms();
            getClients();
        }.bind(this));
    </script>
</clients>
