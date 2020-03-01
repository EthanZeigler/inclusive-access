<template>
    <div class="container pt-4">
        <h4>Welcome to Inclusive Access!</h4>
        <p>Please select a location to continue, or <router-link to="/location/new">create a location</router-link>:</p>
        <div v-if="loading">
            Please wait for the locations to load...
        </div>
        <div v-else>
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
</template>

<script>
    export default {
        data() {
            return {
                loading: true,
                data: []
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
