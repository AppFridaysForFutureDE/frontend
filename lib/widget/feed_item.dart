import 'package:app/app.dart';
import 'package:app/model/post.dart';
import 'package:app/page/feed/post.dart';
import 'package:app/util/share.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeedItemWidget extends StatefulWidget {
  final Post item;
  final bool highlighted;
  final bool showExcerpt;

  final bool isImageLeftAligned;

  FeedItemWidget(this.item,
      {this.highlighted = false,
      this.showExcerpt = true,
      this.isImageLeftAligned = true});

  @override
  _FeedItemWidgetState createState() => _FeedItemWidgetState();
}

class _FeedItemWidgetState extends State<FeedItemWidget> {
  Post get post => widget.item;
  bool get highlighted => widget.highlighted;
  bool get isImageLeftAligned => widget.isImageLeftAligned;

  Widget _buildCategories(TextTheme textTheme) => Text(
        post.tags
            .fold('',
                (previousValue, element) => '$previousValue / ${element.name}')
            .substring(3),
        style: textTheme.overline.copyWith(fontSize: 14),
      );

  @override
  Widget build(BuildContext context) {
    bool read = Hive.box('post_read').get(post.id) ?? false;
    bool marked = Hive.box('post_mark').get(post.id) ?? false;

    var textTheme = Theme.of(context).textTheme;

    if (read) {
      textTheme = textTheme.apply(
        bodyColor: Theme.of(context).hintColor,
      );
    }

    return InkWell(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostPage(post),
          ),
        );
        setState(() {});
      },
      child: Column(
        children: [
          if (highlighted)
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CachedNetworkImage(
                  imageUrl: post.featureImage ?? '',
                  width: double.infinity,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: _buildCategories(textTheme),
                    ),
                  ),
                ),
              ],
            ),
          Stack(
            alignment: highlighted ? Alignment.bottomLeft : Alignment.topRight,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        if (post.featureImage != null &&
                            !highlighted &&
                            isImageLeftAligned) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: CachedNetworkImage(
                              imageUrl: post.featureImage ?? '',
                              width: 80,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (!highlighted) ...[
                                _buildCategories(textTheme),
                                SizedBox(
                                  height: 2,
                                ),
                              ],
                              ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 32),
                                child: Text(
                                  post.title,
                                  style: textTheme.headline5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (post.featureImage != null &&
                            !highlighted &&
                            !isImageLeftAligned) ...[
                          SizedBox(
                            width: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: CachedNetworkImage(
                              imageUrl: post.featureImage ?? '',
                              width: 80,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (widget.showExcerpt && post.customExcerpt != null)
                      Text(
                        post.customExcerpt,
                        style: textTheme.bodyText2,
                      ),
                    if (highlighted)
                      SizedBox(
                        height: 32,
                      ),
                    /*        Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            children: <Widget>[
                              for (var tag in post.tags)
                                Chip(
                                  label: Text(
                                    tag.name,
                                    style: textTheme.body1,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          'vor ' + TimeAgoUtil.render(post.publishedAt),
                          style: textTheme.body1,
                        ),
                      ],
                    ), */
                  ],
                ),
              ),
              /*   Align(
                alignment:
                    highlighted ? Alignment.bottomLeft : Alignment.topRight,
                child: */
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (highlighted)
                    IconButton(
                      icon: Icon(
                        MdiIcons.shareVariant,
                        semanticLabel: 'Artikel teilen',
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        ShareUtil.sharePost(post);
                      },
                    ),
                  IconButton(
                    icon: Icon(
                      marked ? MdiIcons.bookmark : MdiIcons.bookmarkOutline,
                      color:
                          marked ? Theme.of(context).accentColor : Colors.grey,
                      semanticLabel: 'Artikel markieren',
                    ),
                    onPressed: () {
                      setState(() {
                        Hive.box('post_mark').put(post.id, !marked);
                      });
                    },
                  ),
                  if (!isImageLeftAligned)
                    SizedBox(
                      width: 90,
                    ),
                ],
              ),
              /*  ), */
/*               Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: Platform.isAndroid
                      ? <Widget>[
                          if (marked)
                            Icon(
                              MdiIcons.bookmark,
                              color: Theme.of(context).accentColor,
                              semanticLabel: 'Markierter Artikel',
                            ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              semanticLabel: 'Menü anzeigen',
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(marked
                                    ? 'Markierung entfernen'
                                    : 'Markieren'),
                                value: 'mark',
                              ),
                              PopupMenuItem(
                                child: Text('Teilen...'),
                                value: 'share',
                              ),
                              if (read)
                                PopupMenuItem(
                                  child: Text('Als ungelesen kennzeichnen'),
                                  value: 'unread',
                                ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 'mark':
                                  setState(() {
                                    Hive.box('post_mark').put(post.id, !marked);
                                  });
                                  break;
                                case 'share':
                                  ShareUtil.sharePost(post);
                                  break;
                                case 'unread':
                                  setState(() {
                                    Hive.box('post_read').put(post.id, false);
                                  });
                                  break;
                              }
                            },
                          ),
                        ]
                      :
                      //iOS adaption (action sheet)
                      <Widget>[
                          if (marked)
                            Icon(
                              MdiIcons.bookmark,
                              semanticLabel: 'Markierter Artikel',
                              color: Theme.of(context).accentColor,
                            ),
                          CupertinoButton(
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          child: Text(marked
                                              ? 'Markierung entfernen'
                                              : 'Markieren'),
                                          onPressed: () {
                                            setState(() {
                                              Hive.box('post_mark')
                                                  .put(post.id, !marked);
                                            });
                                            Navigator.pop(context, 'Mark');
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: const Text('Teilen...'),
                                          onPressed: () {
                                            ShareUtil.sharePost(post);
                                            Navigator.pop(context, 'Share');
                                          },
                                        ),
                                        if (read)
                                          CupertinoActionSheetAction(
                                            child: const Text(
                                                'Als ungelesen kennzeichnen'),
                                            onPressed: () {
                                              setState(() {
                                                Hive.box('post_read')
                                                    .put(post.id, false);
                                              });
                                              Navigator.pop(context, 'Read');
                                            },
                                          )
                                      ],
                                      //cancel button
                                      cancelButton: CupertinoActionSheetAction(
                                        child: const Text('Abbrechen'),
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context, 'Cancel');
                                        },
                                      ),
                                    );
                                  });
                            },
                            child: Icon(CupertinoIcons.ellipsis,
                                color: Theme.of(context).hintColor),
                          ),
                        ],
                ),
              ), */
            ],
          ),
        ],
      ),
    );
  }
}
