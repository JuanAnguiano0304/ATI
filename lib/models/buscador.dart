import 'package:googleapis/customsearch/v1.dart' as search;
import 'package:googleapis_auth/auth_io.dart' as auth;

class Buscador {
  static Future<List<dynamic>> buscador(
      String busq, var page, dynamic site) async {
    //Método de autenticación
    var authClient =
        auth.clientViaApiKey("AIzaSyCHjniFV2jqjTYQ5UnoIhzzRWFvTr2sR4s");
    var p = search.CustomSearchApi(authClient);
    if (busq == "") {
      return ['Sin búsqueda'];
    } else {
      //Indicador del índice que iniciara.
      var pages = search.SearchQueriesNextPage(
        startPage: page,
      ).startPage;
      if (site == null || site == '*') {
        //Acceso a la funcionalidad de la librería para el buscador
        return p.cse
            .list(
          q: busq, //Búsqueda
          cx: "f0bb038249fba45f1", //ID del buscador personalizado
          start: pages, //Índice de la página
        )
            .then((search.Search val) {
          return prod(val);
        });
      } else {
        return p.cse
            .list(
          q: busq,
          cx: "f0bb038249fba45f1",
          start: pages,
          siteSearch: site, //Sitio específico a buscar
        )
            .then((search.Search val) {
          return prod(val);
        });
      }
    }
  }

  static List<dynamic> prod(search.Search val) {
    String linkImage =
        "https://png.pngtree.com/element_our/20200702/ourlarge/pngtree-no-photography-photo-illustration-image_2292077.jpg";
    List<Map<String, String>> productos = [];
    dynamic totResultados = val.queries!.request![0].toJson();
    for (int i = 0; i < val.items!.length; i++) {
      if (val.items?[i].pagemap == null) {
        productos.add({
          "titulo": val.items![i].title.toString(),
          "link": val.items![i].link.toString(),
          "snippet": val.items![i].snippet.toString(),
          "image": linkImage,
          "tienda": val.items![i].displayLink.toString()
        });
      } else {
        dynamic thumbnail = val.items![i].pagemap!['cse_thumbnail'];
        productos.add({
          "titulo": val.items![i].title.toString(),
          "link": val.items![i].link.toString(),
          "snippet": val.items![i].snippet.toString(),
          "image": thumbnail != null ? thumbnail[0]['src'] : linkImage,
          "tienda": val.items![i].displayLink.toString()
        });
      }
    }
    return [productos, totResultados['totalResults']];
  }
}
