import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_assignment/firebase/firebase_services.dart';
import 'package:flutter_assignment/model/post.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {

  // Initialize variables and objects
  List<Post> posts = [];
  String type = 'hot';
  final ScrollController _scrollController = ScrollController();
  bool loading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final unfocusNode = FocusNode();

  // Animation map for managing animations
  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
      ],
    ),
    'columnOnActionTriggerAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(1, 1),
          end: const Offset(1, 1),
        ),
      ],
    ),
    'columnOnActionTriggerAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(1, 1),
          end: const Offset(1, 1),
        ),
      ],
    ),
    'columnOnActionTriggerAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onActionTrigger,
      applyInitialState: true,
      effects: [
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(1, 1),
          end: const Offset(1, 1),
        ),
      ],
    ),
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 0),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  // FirebaseService instance for fetching and storing posts
  final FirebaseService firebaseService = FirebaseService();

  void fetchAndStorePosts() async {
    if(!loading) {
      setState(() => loading = true);

      try {
        // Fetch posts from FirebaseService
        List<Post> fetchedPosts = [];
        if(posts.isNotEmpty) {
          fetchedPosts = await firebaseService.fetchPosts(type, posts.last.name);
        } else {
          fetchedPosts = await firebaseService.fetchPosts(type, '');
        }
        // Store fetched posts in Firebase using FirebaseService
        await firebaseService.storePosts(fetchedPosts);
        // Update the UI with the fetched posts
        setState(() {
          posts.addAll(fetchedPosts);
          loading = false;
        });
      } catch (e) {
        setState(() => loading = false);
        log('Error: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    setupAnimations(
      animationsMap.values.where((anim) =>
      anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    // Scroll listener to fetch more posts when reaching the end of the list
    _scrollController.addListener(_scrollListener);
    fetchAndStorePosts();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchAndStorePosts();
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Adjust system UI overlay style if running on iOS
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            '/r/FlutterDev',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: FlutterFlowTheme.of(context).primaryText,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        setState(() {
                          posts.clear();
                          type = 'hot';
                        });
                        fetchAndStorePosts();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                            child: Text(
                              'Hot',
                              style: type == 'hot'? FlutterFlowTheme.of(context).bodyMedium : FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 1,
                            decoration: BoxDecoration(
                              color: type == 'hot'? const Color(0xFF4E4CEC) : FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                        ],
                      ),
                    ).animateOnActionTrigger(
                      animationsMap['columnOnActionTriggerAnimation1']!,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        setState(() {
                          posts.clear();
                          type = 'new';
                        });
                        fetchAndStorePosts();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                            child: Text(
                              'New',
                              style: type == 'new'? FlutterFlowTheme.of(context).bodyMedium : FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 1,
                            decoration: BoxDecoration(
                              color: type == 'new'? const Color(0xFF4E4CEC) : FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                        ],
                      ),
                    ).animateOnActionTrigger(
                      animationsMap['columnOnActionTriggerAnimation1']!,
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        setState(() {
                          posts.clear();
                          type = 'rising';
                        });
                        fetchAndStorePosts();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                            child: Text(
                              'Rising',
                              style: type == 'rising'? FlutterFlowTheme.of(context).bodyMedium : FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context)
                                    .secondaryText,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 1,
                            decoration: BoxDecoration(
                              color: type == 'rising'? const Color(0xFF4E4CEC) : FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                          ),
                        ],
                      ),
                    ).animateOnActionTrigger(
                      animationsMap['columnOnActionTriggerAnimation1']!,
                    ),
                  ],
                ),
              ).animateOnPageLoad(
                  animationsMap['containerOnPageLoadAnimation1']!),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length+1,
                    itemBuilder: (context, index) {
                      if (index < posts.length) {
                        final post = posts[index];
                        // Build UI for each post
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final Uri url = Uri.parse(post.url);

                              if (!await launchUrl(url)) {
                                log('Could not launch $url');
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 2,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFCEF83),
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(-1, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        post.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                          fontFamily: 'Outfit',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: const AlignmentDirectional(-1, 0),
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          10, 0, 10, 10),
                                      child: SelectionArea(
                                          child: Text(
                                            post.selftext,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                              fontFamily: 'Readex Pro',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation2']!),
                        );
                      } else if(loading){
                        return Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ).animateOnPageLoad(
                            animationsMap['containerOnPageLoadAnimation2']!);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ).animateOnPageLoad(
                      animationsMap['columnOnPageLoadAnimation']!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}