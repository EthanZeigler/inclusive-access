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
    export default {
        components: {
            HomeMap
        },
        data() {
            return {
                loading: true,
                data: [],
                loggedIn: this.isUserLoggedIn()
            }
        },
        mounted() {
            console.log("fetching");
            fetch('/locations.json')
                .then((response) => {
                    return response.json();
                })
                .then((data) => {
                    this.data = data;
                    this.loading = false;
                });
        }
    }
</script>
