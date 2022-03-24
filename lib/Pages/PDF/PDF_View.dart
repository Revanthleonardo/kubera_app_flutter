import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:kubera_app/Util/ColorResources.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFPage extends StatefulWidget {
  final String title;
  final String path;
  PDFPage({Key key, this.title,this.path,})
      : super(key: key);
  @override
  State<PDFPage> createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  showUserSnak(String msg, bool flag) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: (flag) ? Colors.black54 : ColorResources.APP_THEME_COLOR,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorResources.APP_THEME_COLOR,
        title:  Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.path,
        key: _pdfViewerKey,
      ),
    );
  }
}
