import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_state.dart';
import '../../theme/app_theme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSw = appState.selectedLanguage == 'sw';

    return Scaffold(
      appBar: AppBar(
        title: Text(isSw ? 'Jumuiya ya Wafugaji' : 'Farmer Community'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPostQuestionDialog(context, appState, isSw),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.post_add_rounded, color: Colors.white, size: 26),
        label: Text(
          isSw ? 'Uliza / Shirikisha' : 'Post Question',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appState.communityPosts.length,
        itemBuilder: (context, index) {
          final post = appState.communityPosts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.amberGold,
                        radius: 22,
                        child: Text(
                          post.authorName[0],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.authorName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('${post.authorLocation} • ${DateFormat('HH:mm, dd MMM').format(post.timestamp)}', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Post Title & Content
                  Text(post.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                  const SizedBox(height: 6),
                  Text(post.content, style: const TextStyle(fontSize: 15, height: 1.4)),
                  const SizedBox(height: 12),

                  if (post.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        post.imageUrl!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  const Divider(),

                  // Actions: Like & Comment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          appState.togglePostLike(post.id);
                        },
                        icon: Icon(
                          post.isLiked ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                          color: post.isLiked ? AppTheme.primaryGreen : Colors.grey,
                          size: 22,
                        ),
                        label: Text(
                          '${post.likesCount} ${isSw ? 'Penda' : 'Likes'}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: post.isLiked ? AppTheme.primaryGreen : Colors.grey.shade800,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showCommentsDialog(context, appState, post.id, post.comments, isSw),
                        icon: const Icon(Icons.comment_rounded, color: AppTheme.infoBlue, size: 22),
                        label: Text(
                          '${post.comments.length} ${isSw ? 'Maoni' : 'Comments'}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.infoBlue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPostQuestionDialog(BuildContext context, AppState appState, bool isSw) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isSw ? 'Shiriki Tajriba au Uliza Swali' : 'Post Question or Experience', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Kichwa cha Swali' : 'Question Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtrl,
                maxLines: 4,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(labelText: isSw ? 'Maelezo ya Kina' : 'Details / Experience'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isSw ? 'Ghairi' : 'Cancel', style: const TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                appState.addCommunityPost(titleCtrl.text, contentCtrl.text, null);
                Navigator.pop(ctx);
              }
            },
            child: Text(isSw ? 'Chapisha Swali' : 'Post Question', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(BuildContext context, AppState appState, String postId, List<String> comments, bool isSw) {
    final commentCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isSw ? 'Maoni ya Wafugaji' : 'Comments', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            if (comments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(isSw ? 'Kuwa wa kwanza kutoa maoni!' : 'Be the first to comment!', style: const TextStyle(fontSize: 16, color: Colors.grey)),
              )
            else
              Container(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: comments.length,
                  itemBuilder: (cCtx, i) => ListTile(
                    leading: const Icon(Icons.account_circle_rounded, color: AppTheme.primaryGreen),
                    title: Text(comments[i], style: const TextStyle(fontSize: 15)),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentCtrl,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: isSw ? 'Andika maoni yako...' : 'Write a comment...',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppTheme.primaryGreen, size: 28),
                  onPressed: () {
                    if (commentCtrl.text.isNotEmpty) {
                      appState.addCommentToPost(postId, commentCtrl.text);
                      commentCtrl.clear();
                      Navigator.pop(ctx);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
