<template>
    <div class="container-fluid pt-2">
        <div v-if="loading">
            Please wait for the locations to load...
        </div>
        <div class="row" v-else>
            <div class="col-md-8 pl-4">
                <HomeMap />
            </div>
            <div class="col-md-4 pt-2">
                <h4>Welcome to Inclusive Access!</h4>
                <p>
                    <router-link class="btn btn-outline-primary btn-block" to="/location/new" v-if="loggedIn">
                        <i class="fas fa-plus fa-fw mr-1"></i>
                        Create Location
                    </router-link>
                    <span v-else>
                        <a href="/user/sign_in">Log in</a> to create a location.
                    </span>
                </p>

                <div class="row">
                    <div class="col-md-4 pr-0">
                        <select class="custom-select">
                            <option value="">All Markers</option>
                            <option>Bathrooms</option>
                            <option>Accessible Entrances</option>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <div class="d-flex mb-4">
                            <b-form-input v-model="searchTerm" class="mr-2 flex-1" placeholder="Search..."></b-form-input>
                            <button type="button" class="btn btn-primary" @click.prevent="loadData()"><i class="fas fa-search fa-fw"></i></button>
                        </div>
                    </div>
                </div>

                <div v-if="data.length < 1">
                    There are no locations to display.
                </div>
                <ul v-else>
                    <li
                            v-for="loc in data"
                            :key="'location-' + loc.id"
                    >
                        <router-link
                                :to="'/location/' + loc.id"
                        >
                            {{ loc.name }}
                        </router-link>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
    import HomeMap from './components/HomeMap';

    let _timer;
    export default {
        components: {
            HomeMap
        },
        data() {
            return {
                loading: true,
                data: [],
                loggedIn: this.isUserLoggedIn(),
                searchTerm: ''
            }
        },
        mounted() {
            this.loadData();
        },
        methods: {
            loadData() {
                clearTimeout(_timer);
                fetch('/locations.json?search_term=' + encodeURIComponent(this.searchTerm))
                    .then((response) => {
                        return response.json();
                    })
                    .then((data) => {
                        this.data = data;
                        this.loading = false;
                    });
            }
        },
        watch: {
            searchTerm() {
                _timer = setTimeout(() => this.loadData(), 500);
            }
        }
    }
</script>
