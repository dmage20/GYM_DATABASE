import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

// import GMaps from 'gmaps/gmaps.js';
import { autocomplete } from '../components/autocomplete';
import { initMapbox } from '../plugins/init_mapbox';
import { showmeclick } from '../components/modal';
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css';

autocomplete();
initMapbox();
showmeclick();
