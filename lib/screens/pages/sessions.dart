import 'package:distraction_destruction/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';

//Display auth info, allowing users to login, register or await auto login
class Sessions extends StatefulWidget {
  const Sessions({Key? key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Welcome Back";
  }

  @override
  _SessionPage createState() => _SessionPage();
}

class _SessionPage extends State<Sessions> with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  bool _session = false;

  List<SessionCardArguments> cardsShown = [
    SessionCardArguments(
        header: CardHeaderArguments(icon:const Icon(Icons.clear), title: "Bopis", subtitle: "Parts"),
        body: CardBodyArguments(),
        footer: CardFooterArguments()
    ),
    SessionCardArguments(
        header: CardHeaderArguments(icon:const Icon(Icons.clear), title: "Bepis", subtitle: "Parts")
    ),
    SessionCardArguments(
    )
  ]; // TODO: generate this based on user's state

  void inSession(bool inSession) {
    _session = inSession;
  }
  String title() {
    return _session ? "Session in Progress" : "Welcome Back ";
  }

  void _incrementCounter() {
    setState(() {
      // tells Flutter framework that something has changed in this State,
      // which causes it to rerun the build method below
      _counter++;
    });
  }

  List<SessionCard> _buildGridCards(List<SessionCardArguments> cardArgs) {
    List<SessionCard> cards = [];
    for (SessionCardArguments i in cardArgs) {
          cards.add(SessionCard.withArguments(i));
    }
    return cards;
  }


  Widget build(BuildContext context) {
    super.build(context);


    return Scaffold(
        body: Center(
          child:
          ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              children: _buildGridCards(cardsShown),
          ),
        )
    );


  // @override
  // Widget build(BuildContext context) {
  //   super.build(context);
  //   return Scaffold(
  //       body: Center(
  //         child:
  //       ListView(
  //           shrinkWrap: true,
  //           padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //           children: _buildGridCards(3) // Replace
  //       ),
  //       )
  //   );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _CardHeaderArguments {

}

class CardHeaderArguments {
  final Icon? icon;
  final String? title;
  final String? subtitle;
  bool show = true;

  CardHeaderArguments(
      {
        this.icon,
        this.title,
        this.subtitle,
        this.show = true
      });

  // const CardHeaderArguments(this.icon, this.title, this.subtitle, {show});
  CardHeaderArguments.hide(this.icon, this.title, this.subtitle) : show = false;
  // CardHeaderArguments.check({icon, title, subtitle, show}) :
  //       this(icon, title, subtitle,
  //         show: show ?? ((icon ?? title ?? subtitle) != null)); // check if visible

  bool get empty {
    return ((icon ?? title ?? subtitle) != null);
  }
}

class CardBodyArguments {
  final Widget? body;
  bool show = true;

  CardBodyArguments({this.body});

  bool get empty {
    return body != null;
  }
}

class CardFooterArguments {
  final List<Widget>? footer;
  bool show = true;
  CardFooterArguments({this.footer});

  bool get empty {
    return footer != null;
  }
}

class SessionCardArguments {
  final CardHeaderArguments? header;
  final CardBodyArguments? body;
  final CardFooterArguments? footer;

  const SessionCardArguments({this.header, this.body, this.footer});
}

class SessionCard extends Card {
  // final List<String> list;

  const SessionCard({
    Key? key,
    this.header,
    this.body,
    this.footer
  }) : super(key: key);

  SessionCard.withArguments(SessionCardArguments arguments)
      : this(header: arguments.header, body: arguments.body, footer: arguments.footer);
  final CardHeaderArguments? header;
  final CardBodyArguments? body;
  final CardFooterArguments? footer;

  bool get showHeading {
    return header?.show ?? header?.empty ?? false;
  }

  bool get showBody {
    return body?.show ?? body?.empty ?? false;
  }

  bool get showFooter {
    return footer?.show ?? footer?.empty ?? false;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> parts = [];

    if (showHeading) {
      parts.add(
          ListTile(
            leading: header?.icon,
            title: (header?.title != null) ? Text(header!.title!) : null,
            subtitle: (header?.subtitle != null) ? Text(header!.subtitle!) : null,
            onTap: () {},
            onLongPress: () {},
          ));
    }

    if (showBody) {
      parts.add(
        Padding(                      /* ========== CONTENT =========== */
          padding: const EdgeInsets.all(16.0),
          child: body?.body,
        ),
      );
    }

    if (showFooter) {
      parts.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: footer?.footer ?? [],
        )
      );
    }

    if (parts.isEmpty) {
      parts.add(Padding(padding:EdgeInsets.zero));
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...parts         /* ========== BUTTONS =========== */
        ],
      ),
    );
  }
}