<template>
    <div class="pt-4">
        <p>To create a location, click the center of the target, and then move your mouse to create a circle.</p>

        <div id="map"></div>

        <b-modal ref="createModal"
                 title="Create Location"
                 @show="resetModal"
                 @hidden="resetModal"
                 @ok="handleOk"
                 ok-title="Create"
                 :no-close-on-backdrop="true"
                 :no-close-on-esc="true"
        >
            <form ref="form"
                  @submit.stop.prevent="handleSubmit"
            >
                <b-form-group
                        :state="createState.nameState"
                        label="Name"
                        label-for="name-input"
                        invalid-feedback="Name is required"
                >
                    <b-form-input
                            id="name-input"
                            v-model="createState.name"
                            :state="createState.nameState"
                            required
                    />
                </b-form-group>
                <b-form-group
                        :state="createState.descriptionState"
                        label="Description"
                        label-for="description-input"
                        invalid-feedback="Description is required"
                >
                    <b-form-textarea
                            id="description-input"
                            v-model="createState.description"
                            :state="createState.descriptionState"
                            required
                    />
                </b-form-group>
            </form>
        </b-modal>
    </div>
</template>
<style>
    #map {
        height: calc(100vh - 200px);
    }
</style>

<script>
    import 'ol/ol.css';

    import axios from 'axios';
    import {fromLonLat} from 'ol/proj';
    import Map from 'ol/Map.js';
    import View from 'ol/View.js';
    import Draw from 'ol/interaction/Draw.js';
    import {Tile as TileLayer, Vector as VectorLayer} from 'ol/layer.js';
    import {OSM, Vector as VectorSource} from 'ol/source.js';
    import {Feature} from "ol";
    import Circle from "ol/geom/Circle";

    export default {
        data() {
            return {
                createState: {
                    name: '',
                    nameState: null,
                    description: '',
                    descriptionState: null
                },
                lat: null,
                lon: null,
                radius: null
            }
        },
        methods: {
            checkFormValidity() {
                const valid = this.$refs.form.checkValidity();

                if (this.createState.name.trim().length < 3)
                    this.createState.nameState = false;
                else
                    this.createState.nameState = null;

                if (this.createState.description.trim().length < 1)
                    this.createState.descriptionState = false;
                else
                    this.createState.descriptionState = null;

                return valid;
            },
            resetModal() {
                this.createState.name = '';
                this.createState.nameState = null;
                this.createState.description = '';
                this.createState.descriptionState = null;
            },
            handleOk(bvModalEvt) {
                bvModalEvt.preventDefault();

                this.handleSubmit();
            },
            handleSubmit() {
                // Exit when the form isn't valid
                if (!this.checkFormValidity()) {
                    return;
                }

                let fields = {
                    authenticity_token: document.head.querySelector("meta[name='csrf-token']").content,
                    location: {
                        name: this.createState.name,
                        description: this.createState.description,
                        lat: this.lat,
                        long: this.lon,
                        radius: this.radius,
                    }
                };

                axios.post('/locations.json', fields)
                    .then((response) => {
                        console.log(response.data);
                        this.$nextTick(() => {
                            this.$refs.createModal.hide();
                            this.$router.push('/location/' + response.data.id);
                        });
                    })
                    .catch((error) => {
                        alert("There was an error. :(");
                        console.log(error);
                    });


                // Hide the modal manually
                /*
                this.$nextTick(() => {
                    this.$refs.createModal.hide();
                });
                */
            }
        },
        mounted() {
            //this.setup();
            var raster = new TileLayer({
                source: new OSM()
            });

            var source = new VectorSource({wrapX: false});

            var vector = new VectorLayer({
                source: source
            });

            var map = new Map({
                layers: [raster, vector],
                target: 'map',
                view: new View({
                    center: [-11000000, 4600000],
                    zoom: 4
                })
            });

            var draw; // global so we can remove it later
            function addInteraction() {
                var geometryFunction;
                draw = new Draw({
                    source: source,
                    type: 'Circle',
                    geometryFunction: geometryFunction
                });
                map.addInteraction(draw);
            }

            addInteraction();

            draw.on('drawend', async () => {
                /*
                 WARNING: HACK!!!!!!!!!!!
                 BAD HACK!!!!!!!!!!!!!!!!
                 BAD!!!!!!!!!!!!!!!!!!!!!
                 NOT GOOD!!!!!!!!!!!!!!!!

                 Seemingly, drawend is fired before the feature array is updated.
                 We have to wait for a change, probably. So let's do that. Probably.
                */

                // Save the current feature array length
                let cur = vector.getSource().getFeatures().length;

                let tries = 0;
                // Has the length changed yet?
                while (vector.getSource().getFeatures().length === cur &&
                    tries <= 40 /* 40*25=1000; 1s */) {
                    await new Promise(r => setTimeout(r, 25));
                    tries++;
                    console.log(tries);
                }

                let features = vector.getSource().getFeatures();
                let feature = features[features.length - 1];
                console.log(feature);
                console.log(feature.values_.geometry);

                let radius = feature.values_.geometry.getRadius();
                let center = feature.values_.geometry.transform('EPSG:3857', 'EPSG:4326').getCenter();
                let lon = center[0];
                let lat = center[1];

                console.log("lon: " + lon);
                console.log("lat: " + lat);
                console.log("radius: " + radius);

                this.lon = lon;
                this.lat = lat;
                this.radius = radius;

                this.$refs.createModal.show();
            });

            let cr = fromLonLat([-74.77742239248158, 40.26845240085373]);
            source.addFeature(new Feature(new Circle(cr, 685.6964866677299)));
        }
    }
</script>