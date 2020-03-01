<template>
    <div class="container-fluid pt-4">
        <div class="row" v-if="!loading && markTypes !== null && marks !== null">
            <div class="col-md-9 pl-4" id="map-container">
                <div id="map-loc" class="shadow"></div>
            </div>
            <div class="col-md-3">
                <h4>{{ location.name }}</h4>
                <p class="mb-5">{{ location.description }}</p>

                <h5>Markers</h5>
                <p v-if="loggedIn"><a href="#" @click.prevent="editing = !editing">{{ editing ? "Stop Editing" : "Edit Markers" }}</a></p>
                <p v-else>Log in to add points.</p>

                <div v-if="!editing">
                    <p v-for="mark in marks" :key="'mark-loc-' + location.id + '-' + mark.id">
                        <a href="#" @click.prevent="showPopup(mark)">
                            [{{ getMarkType(mark) }}]
                            {{ mark.name }}
                        </a>
                    </p>
                </div>
            </div>
        </div>
        <div class="container" v-else>
            <strong>Loading location...</strong>
        </div>
    </div>
</template>
<style>
    #map-loc {
        height: calc(100vh - 150px);
    }

    .ol-popup {
        font-size: 12px;
        position: absolute;
        background-color: white;
        -webkit-filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
        filter: drop-shadow(0 1px 4px rgba(0, 0, 0, 0.2));
        padding: 15px;
        border-radius: 10px;
        border: 1px solid #cccccc;
        bottom: 12px;
        left: -50px;
        min-width: 150px;
    }

    .ol-popup:after,
    .ol-popup:before {
        top: 100%;
        border: solid transparent;
        content: " ";
        height: 0;
        width: 0;
        position: absolute;
        pointer-events: none;
    }

    .ol-popup:after {
        border-top-color: white;
        border-width: 10px;
        left: 48px;
        margin-left: -10px;
    }

    .ol-popup:before {
        border-top-color: #cccccc;
        border-width: 11px;
        left: 48px;
        margin-left: -11px;
    }

    .ol-popup-closer {
        text-decoration: none;
        position: absolute;
        top: 2px;
        right: 8px;
    }

    .ol-popup-closer:after {
        content: "✖";
        color: #c3c3c3;
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
    import axios from "axios";
    import Point from "ol/geom/Point";
    import Overlay from "ol/Overlay";
    import {Icon, Style} from 'ol/style';

    export default {
        data() {
            return {
                coordinates: null,
                loading: true,
                markTypes: null,
                location: null,
                marks: null,
                map: null,
                _overlay: null,
                _content: null,
                editing: false,
                loggedIn: this.isUserLoggedIn()
            }
        },
        computed: {
            id() {
                return this.$route.params.id;
            }
        },
        methods: {
            escape(str) {
                // https://stackoverflow.com/q/5499078
                return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
            },
            showPopup(m) {
                this._content.innerHTML = `<strong>Name: </strong> ${this.escape(m.name)}<br><strong>Type: </strong>${this.escape(this.getMarkType(m))}`;
                this._overlay.setPosition(fromLonLat([m.long, m.lat]));
            },
            getMarkType(m) {
                return this.markTypes.find(x => x.id === m.mark_type_id).name;
            },
            async setupMarks(source) {
                while (this.marks === null) {
                    await new Promise(r => setTimeout(r, 25));
                }
                for (let i = 0; i < this.marks.length; i++) {
                    let mark = this.marks[i];

                    let coordinate = fromLonLat([mark.long, mark.lat]);

                    var feature = new Feature({
                        geometry: new Point(coordinate),
                        name: mark.name,
                    });

                    feature.set('name', name);
                    feature.set('mark', mark);

                    var style = new Style({
                        image: new Icon({
                            anchor: [0.5, 46],
                            anchorXUnits: 'fraction',
                            anchorYUnits: 'pixels',
                            src: '/img/pin.png'
                        })
                    });

                    feature.setStyle(style);
                    source.addFeature(feature);
                }
            },
            setupMap() {
                var raster = new TileLayer({
                    source: new OSM()
                });

                var source = new VectorSource({wrapX: false});

                var vector = new VectorLayer({
                    source: source
                });

                var map = new Map({
                    layers: [raster, vector],
                    target: 'map-loc',
                    view: new View({
                        center: fromLonLat([this.lon, this.lat]),
                        zoom: 16
                    })
                });

                this.map = map;

                let coordinate = fromLonLat([this.lon, this.lat]);
                source.addFeature(new Feature(new Circle(coordinate, this.radius)));

                if (this.editing) {
                    if (this.isUserLoggedIn()) {
                        let draw = new Draw({
                            source: source,
                            type: "Point"
                        });
                        map.addInteraction(draw);

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
                            }

                            let features = vector.getSource().getFeatures();
                            let feature = features[features.length - 1];

                            this.coordinates = JSON.parse(JSON.stringify(feature.values_.geometry.transform('EPSG:3857', 'EPSG:4326').getCoordinates()));

                            source.removeFeature(feature);
                        });
                    }
                } else {
                    const popupHtml = `<div id="popup" class="ol-popup">
                        <a href="#" id="popup-closer" class="ol-popup-closer"></a>
                        <div id="popup-content"></div>
                    </div>`;
                    var template = document.createElement('template');
                    template.innerHTML = popupHtml;
                    document.getElementById('map-container').appendChild(template.content.firstChild);

                    // https://openstreetmap.be/en/projects/howto/openlayers.html
                    var container = document.getElementById('popup');
                    this._content = document.getElementById('popup-content');
                    var closer = document.getElementById('popup-closer');

                    this._overlay = new Overlay({
                        element: container,
                        autoPan: true,
                        autoPanAnimation: {
                            duration: 250
                        }
                    });
                    map.addOverlay(this._overlay);

                    closer.onclick = function() {
                        this._overlay.setPosition(undefined);
                        closer.blur();
                        return false;
                    };

                    map.on('singleclick',   (event) => {
                        var feature = map.forEachFeatureAtPixel(event.pixel,
                            function (feature) {
                                return feature;
                            });

                        if (feature && typeof feature.get('mark') !== 'undefined') {
                            let mark = feature.get('mark');

                            this._content.innerHTML = `<strong>Name: </strong> ${this.escape(mark.name)}<br><strong>Type: </strong>${this.escape(this.getMarkType(mark))}`;
                            this._overlay.setPosition(event.coordinate);
                        } else {
                            this._overlay.setPosition(undefined);
                            closer.blur();
                        }
                    });

                    this.setupMarks(source);
                }
            }
        },
        mounted() {
            axios.get('/marks.json?location_id=' + this.id)
                .then((response) => {
                    this.marks = response.data;
                })
                .catch((error) => {
                    alert('Unable to fetch mark types :(');
                    console.log(error);
                });

            axios.get('/mark_types.json')
                .then((response) => {
                    this.markTypes = response.data;
                })
                .catch((error) => {
                    alert('Unable to fetch mark types :(');
                    console.log(error);
                });

            axios.get('/locations/' + this.id + '.json')
                .then((response) => {
                    let data = response.data;

                    this.location = data;

                    this.lon = parseFloat(data.long);
                    this.lat = parseFloat(data.lat);
                    this.radius = parseFloat(data.radius);

                    this.loading = false;

                    setTimeout(() => {
                        this.$nextTick(() => {
                            this.setupMap();
                        });
                    }, 50);
                });
        },
        watch: {
            editing() {
                this.map.setTarget(null);
                this.map = null;
                this.setupMap();
            }
        }
    }
</script>