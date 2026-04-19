import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: LucideIcons.layoutDashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                ),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.activity,
                  title: 'Assessments',
                  route: '/dashboard', // Placeholder
                ),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.messageSquare,
                  title: 'AI Chatbot',
                  route: '/chatbot',
                ),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.barChart2,
                  title: 'Risk Reports',
                  route: '/dashboard', // Placeholder
                ),
                const Divider(height: 32),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.settings,
                  title: 'Settings',
                  route: '/dashboard', // Placeholder
                ),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.helpCircle,
                  title: 'Help & Support',
                  route: '/dashboard', // Placeholder
                ),
              ],
            ),
          ),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return UserAccountsDrawerHeader(
      decoration: const BoxDecoration(color: AppTheme.primary),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Text('ES', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
      ),
      accountName: const Text(
        'Esmael Saleh',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      accountEmail: const Text('esmael@example.com'),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required String route}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 22),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      onTap: () {
        context.pop(); // Close drawer
        context.go(route);
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: OutlinedButton.icon(
        onPressed: () => context.go('/'),
        icon: const Icon(LucideIcons.logOut, size: 18, color: Colors.red),
        label: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          side: const BorderSide(color: Color(0xFFFFD8D8)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
