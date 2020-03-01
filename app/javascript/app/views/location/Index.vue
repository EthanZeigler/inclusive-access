<template>
    <div class="pt-4">
        <div id="map"></div>
    </div>
</template>
<style>
    #map {
        height: calc(100vh - 200px);
    }
</style>

<script>
    import 'ol/ol.css';

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
                lat: null,
                lon: null,
                radius: null,
            }
        },
        computed: {
            id() {
                return this.$route.params.id;
            }
        },
        methods: {
            setupMap()
            {
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
                        center: fromLonLat([this.lon, this.lat]),
                        zoom: 16
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
                });

                let coordinate = fromLonLat([this.lon, this.lat]);
                source.addFeature(new Feature(new Circle(coordinate, this.radius)));
            }
        },
        mounted() {
            fetch('/locations/' + this.id + '.json')
                .then((response) => {
                    return response.json();
                })
                .then((data) => {
                    this.lon = parseFloat(data.long);
                    this.lat = parseFloat(data.lat);
                    this.radius = parseFloat(data.radius);

                    this.setupMap();
                });
        }
    }
</script>