import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const html = '''
<!DOCTYPE html>
<html>
	<head/>

		<script src="https://cdn.jsdelivr.net/npm/ol@v7.1.0/dist/ol.js"></script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v7.1.0/ol.css">
		
		<script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.8.0/proj4.js" integrity="sha512-ha3Is9IgbEyIInSb+4S6IlEwpimz00N5J/dVLQFKhePkZ/HywIbxLeEu5w+hRjVBpbujTogNyT311tluwemy9w==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>



	</head>
  <style>
  .ol-zoom {
    top: 52px;
  }
    .ol-toggle-options {
      z-index: 1000;
      background: rgba(255,255,255,0.4);
      border-radius: 4px;
      padding: 2px;
      position: absolute;
      left: 8px;
      top: 8px;
    }
    #updateFilterButton, #resetFilterButton {
      height: 22px;
      width: 22px;
      text-align: center;
      text-decoration: none !important;
      line-height: 22px;
      margin: 1px;
      font-family: "Lucida Grande",Verdana,Geneva,Lucida,Arial,Helvetica,sans-serif;
      font-weight: bold !important;
      background: rgba(0,60,136,0.5);
      color: white !important;
      padding: 2px;
    }
    .ol-toggle-options a {
      background: rgba(0,60,136,0.5);
      color: white;
      display: block;
      font-family: "Lucida Grande",Verdana,Geneva,Lucida,Arial,Helvetica,sans-serif;
      font-size: 19px;
      font-weight: bold;
      height: 22px;
      line-height: 11px;
      margin: 1px;
      padding: 0;
      text-align: center;
      text-decoration: none;
      width: 22px;
      border-radius: 2px;
    }
    .ol-toggle-options a:hover {
      color: #fff;
      text-decoration: none;
      background: rgba(0,60,136,0.7);
    }
    body {
      font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
      font-size: small;
    }
    iframe {
      width: 100%;
      height: 250px;
      border: none;
    }
    /* Toolbar styles */
    #toolbar {
      position: relative;
      padding-bottom: 0.5em;
    }
    #toolbar ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    #toolbar ul li {
      float: left;
      padding-right: 1em;
      padding-bottom: 0.5em;
    }
    #toolbar ul li a {
      font-weight: bold;
      font-size: smaller;
      vertical-align: middle;
      color: black;
      text-decoration: none;
    }
    #toolbar ul li a:hover {
      text-decoration: underline;
    }
    #toolbar ul li * {
      vertical-align: middle;
    }
    #map {
      clear: both;
      position: relative;
      height:100vh; 
      width:100vw;
        border: 1px solid black;
    }
    #wrapper {
      width: 434px;
    }
    #location {
      float: right;
    }
    /* Styles used by the default GetFeatureInfo output, added to make IE happy */
    table.featureInfo, table.featureInfo td, table.featureInfo th {
      border: 1px solid #ddd;
      border-collapse: collapse;
      margin: 0;
      padding: 0;
      font-size: 90%;
      padding: .2em .1em;
    }
    table.featureInfo th {
      padding: .2em .2em;
      font-weight: bold;
      background: #eee;
    }
    table.featureInfo td {
      background: #fff;
    }
    table.featureInfo tr.odd td {
      background: #eee;
    }
    table.featureInfo caption {
      text-align: left;
      font-size: 100%;
      font-weight: bold;
      padding: .2em .2em;
    }
    </style>

	<body>
	
     
			 <div id="map"/>
       <script>
ol.proj.useGeographic();
				var format = "image/png";
				/*var untiled = new ol.layer.Image({
					source: new ol.source.ImageWMS({
						ratio: 1,
						url: "http://localhost:8080/geoserver/mapa/wms",
						params: {"FORMAT": format,
							"VERSION": "1.3.0",  
							"STYLES": "",
							"WIDTH": 256, "HEIGHT": 256,
							"LAYERS": "mapa:geometry-apolices2-5",
							"exceptions": "application/vnd.ogc.se_inimage",
						}
					})
				});*/
				var mousePositionControl = new ol.control.MousePosition({
					className: "custom-mouse-position",
					target: document.getElementById("location"),
					coordinateFormat: ol.coordinate.createStringXY(5),
					undefinedHTML: "&nbsp;"
				});
				var tiled = new ol.layer.Tile({
					visible: true,
					source: new ol.source.TileWMS({
						url: "http://ourobranco.ufsj.edu.br:443/geoserver/mapa/wms",
						params: {"FORMAT": format, 
							"VERSION": "1.3.0",
							"TILED": true,
							"STYLES": "",
							"LAYERS": "mapa:apolices2",
							"exceptions": "application/vnd.ogc.se_inimage",
							tilesOrigin: -56.55622135530706 + "," + -31.21237
						}
					})
				});
				proj4.defs("EPSG:4674","+proj=longlat +ellps=GRS80 +towgs84=0,0,0 +no_defs")
				//ol.proj.setProj4(proj4)
				ol.proj.proj4.register(proj4);
				console.log(ol.proj)

				var projection = new ol.proj.Projection({
					code: "EPSG:4674",
					units: "degrees",
					axisOrientation: "neu",
					global: true
				})
				var attribution = new ol.control.Attribution({
					collapsible: false
				});

				var map = new ol.Map({
					controls: [],
					layers: [

						new ol.layer.Tile({
							source:new ol.source.XYZ({
    url: "http://mt1.google.com/vt/lyrs=s&hl=pl&&x={x}&y={y}&z={z}",
    maxZoom: 19
  })  
						}),
						tiled
					],
					pixelRatio:1,
					target: "map",
					view: new ol.View({
						maxZoom: 20,
						projection:"EPSG:4326",
						zoom: 2
					})
				});
				var bounds = [-56.55622135530706, -31.21237,
					-45.501004146498275, -11.681203493427798];
				map.getView().fit(bounds, map.getSize());
		
				map.getView().animate({zoom: 7, center: ol.proj.transform([-43.4724,-20.216287],new ol.proj.Projection("EPSG:4326"),new ol.proj.Projection("EPSG:4674")),
});

     </script>

		
			
	</body>






''';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadHtmlString(html);
  Future<void> _onLoadHtmlStringExample() {
    return controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("App Map")),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                height: MediaQuery.of(context).size.height - 115,
                width: MediaQuery.of(context).size.width,
                child: WebViewWidget(
                  controller: controller,
                ))
          ],
        ));
  }
}
