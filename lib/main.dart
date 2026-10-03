import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


final ValueNotifier<String> playmixoLanguageCode =
    ValueNotifier<String>('en');
final ValueNotifier<bool> playmixoLanguageChangeEnabled =
    ValueNotifier<bool>(true);

/* ================= SPLASH ================= */

class PlaymixoTranslations {
static const Map<String, Map<String, String>> _translations = {
  'en': {
    'welcome': 'Welcome to PLAYMIXO',
    'home': 'Home',
    'room': 'Room',
    'game': 'Game',
    'wallet': 'Wallet',
    'profile': 'Profile',
    'setting': 'Setting',
    'privacy': 'Privacy',
    'account': 'Account',
    'language': 'Language',
    'help_center': 'Help Center',
    'logout': 'Log Out',
    'delete_account': 'Delete Account',
    'change_email': 'Change Email',
'change_password': 'Change Password',
'account_information': 'Account Information',
'linked_accounts': 'Linked Accounts',
    'name': 'Name',
'email': 'Email',
'mobile_number': 'Mobile Number',
'uid': 'UID',
    'new_email': 'New Email',
'verification_email_sent': 'Verification email sent. Please verify your new email.',
    'new_password': 'New Password',
'confirm_password': 'Confirm Password',
'password_changed': 'Password changed successfully',
'passwords_not_match': 'Passwords do not match',
    'faq': 'Frequently Asked Questions',
'contact_support': 'Contact Support',
'report_problem': 'Report a Problem',
'logout_confirm': 'Are you sure you want to log out?',
'yes': 'Yes',
'no': 'No',
'delete_confirm': 'Are you sure you want to permanently delete your account?',
'permanent_action': 'This action is permanent.',
'delete_password_message': 'Enter your password to permanently delete your account.',
'password': 'Password',
'delete_permanently': 'Delete Account Permanently',
'please_enter_password': 'Please enter your password',
'incorrect_password': 'Incorrect password',
'login_again': 'Please log in again and try again',
'something_wrong': 'Something went wrong',
   'google_account': 'Google Account', 
    'facebook_account': 'Facebook Account',
  },

  'ur': {
    'welcome': 'PLAYMIXO میں خوش آمدید',
    'home': 'ہوم',
    'room': 'روم',
    'game': 'گیم',
    'wallet': 'والٹ',
    'profile': 'پروفائل',
    'setting': 'سیٹنگ',
    'privacy': 'پرائیویسی',
    'account': 'اکاؤنٹ',
    'language': 'زبان',
    'help_center': 'مدد مرکز',
    'logout': 'لاگ آؤٹ',
    'delete_account': 'اکاؤنٹ حذف کریں',
    'change_email': 'ای میل تبدیل کریں',
'change_password': 'پاس ورڈ تبدیل کریں',
'account_information': 'اکاؤنٹ کی معلومات',
'linked_accounts': 'منسلک اکاؤنٹس',
    'name': 'نام',
'email': 'ای میل',
'mobile_number': 'موبائل نمبر',
'uid': 'یو آئی ڈی',
    'new_email': 'نیا ای میل',
'verification_email_sent': 'تصدیقی ای میل بھیج دی گئی ہے۔ براہ کرم اپنے نئے ای میل کی تصدیق کریں۔',
    'new_password': 'نیا پاس ورڈ',
'confirm_password': 'پاس ورڈ کی تصدیق کریں',
'password_changed': 'پاس ورڈ کامیابی سے تبدیل ہو گیا',
'passwords_not_match': 'پاس ورڈز مماثل نہیں ہیں',
    'faq': 'اکثر پوچھے گئے سوالات',
'contact_support': 'سپورٹ سے رابطہ کریں',
'report_problem': 'مسئلہ رپورٹ کریں',
'logout_confirm': 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟',
'yes': 'ہاں',
'no': 'نہیں',
'delete_confirm': 'کیا آپ واقعی اپنا اکاؤنٹ مستقل طور پر حذف کرنا چاہتے ہیں؟',
'permanent_action': 'یہ کارروائی مستقل ہے۔',
'delete_password_message': 'اپنا اکاؤنٹ مستقل طور پر حذف کرنے کے لیے پاس ورڈ درج کریں۔',
'password': 'پاس ورڈ',
'delete_permanently': 'اکاؤنٹ مستقل طور پر حذف کریں',
'please_enter_password': 'براہ کرم اپنا پاس ورڈ درج کریں',
'incorrect_password': 'غلط پاس ورڈ',
'login_again': 'براہ کرم دوبارہ لاگ اِن کریں اور دوبارہ کوشش کریں',
'something_wrong': 'کچھ غلط ہو گیا',
    'google_account': 'گوگل اکاؤنٹ',
   'facebook_account': 'فیس بک اکاؤنٹ', 
  },

  'hi': {
    'welcome': 'PLAYMIXO में आपका स्वागत है',
    'home': 'होम',
    'room': 'रूम',
    'game': 'गेम',
    'wallet': 'वॉलेट',
    'profile': 'प्रोफ़ाइल',
    'setting': 'सेटिंग',
    'privacy': 'प्राइवेसी',
    'account': 'अकाउंट',
    'language': 'भाषा',
    'help_center': 'सहायता केंद्र',
    'logout': 'लॉग आउट',
    'delete_account': 'अकाउंट हटाएं',
    'change_email': 'ईमेल बदलें',
'change_password': 'पासवर्ड बदलें',
'account_information': 'अकाउंट की जानकारी',
'linked_accounts': 'लिंक किए गए अकाउंट',
    'name': 'नाम',
'email': 'ईमेल',
'mobile_number': 'मोबाइल नंबर',
'uid': 'यूआईडी',
    'new_email': 'नया ईमेल',
'verification_email_sent': 'सत्यापन ईमेल भेज दिया गया है। कृपया अपने नए ईमेल की पुष्टि करें।',
    'new_password': 'नया पासवर्ड',
'confirm_password': 'पासवर्ड की पुष्टि करें',
'password_changed': 'पासवर्ड सफलतापूर्वक बदल दिया गया',
'passwords_not_match': 'पासवर्ड मेल नहीं खाते',
    'faq': 'अक्सर पूछे जाने वाले प्रश्न',
'contact_support': 'सपोर्ट से संपर्क करें',
'report_problem': 'समस्या की रिपोर्ट करें',
'logout_confirm': 'क्या आप वाकई लॉग आउट करना चाहते हैं?',
'yes': 'हाँ',
'no': 'नहीं',
'delete_confirm': 'क्या आप वाकई अपना अकाउंट स्थायी रूप से हटाना चाहते हैं?',
'permanent_action': 'यह कार्रवाई स्थायी है।',
'delete_password_message': 'अपना अकाउंट स्थायी रूप से हटाने के लिए पासवर्ड दर्ज करें।',
'password': 'पासवर्ड',
'delete_permanently': 'अकाउंट स्थायी रूप से हटाएं',
'please_enter_password': 'कृपया अपना पासवर्ड दर्ज करें',
'incorrect_password': 'गलत पासवर्ड',
'login_again': 'कृपया दोबारा लॉग इन करें और फिर कोशिश करें',
'something_wrong': 'कुछ गलत हो गया',
  'google_account': 'Google अकाउंट',  
    'facebook_account': 'Facebook अकाउंट',
  },

  'ar': {
    'welcome': 'مرحباً بك في PLAYMIXO',
    'home': 'الرئيسية',
    'room': 'الغرفة',
    'game': 'اللعبة',
    'wallet': 'المحفظة',
    'profile': 'الملف الشخصي',
    'setting': 'الإعدادات',
    'privacy': 'الخصوصية',
    'account': 'الحساب',
    'language': 'اللغة',
    'help_center': 'مركز المساعدة',
    'logout': 'تسجيل الخروج',
    'delete_account': 'حذف الحساب',
    'change_email': 'تغيير البريد الإلكتروني',
'change_password': 'تغيير كلمة المرور',
'account_information': 'معلومات الحساب',
'linked_accounts': 'الحسابات المرتبطة',
    'name': 'الاسم',
'email': 'البريد الإلكتروني',
'mobile_number': 'رقم الهاتف',
'uid': 'معرّف المستخدم',
    'new_email': 'البريد الإلكتروني الجديد',
'verification_email_sent': 'تم إرسال رسالة التحقق. يرجى تأكيد بريدك الإلكتروني الجديد.',
    'new_password': 'كلمة المرور الجديدة',
'confirm_password': 'تأكيد كلمة المرور',
'password_changed': 'تم تغيير كلمة المرور بنجاح',
'passwords_not_match': 'كلمتا المرور غير متطابقتين',
    'faq': 'الأسئلة الشائعة',
'contact_support': 'تواصل مع الدعم',
'report_problem': 'الإبلاغ عن مشكلة',
'logout_confirm': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
'yes': 'نعم',
'no': 'لا',
'delete_confirm': 'هل أنت متأكد أنك تريد حذف حسابك نهائيًا؟',
'permanent_action': 'هذا الإجراء نهائي.',
'delete_password_message': 'أدخل كلمة المرور لحذف حسابك نهائيًا.',
'password': 'كلمة المرور',
'delete_permanently': 'حذف الحساب نهائيًا',
'please_enter_password': 'يرجى إدخال كلمة المرور',
'incorrect_password': 'كلمة المرور غير صحيحة',
'login_again': 'يرجى تسجيل الدخول مرة أخرى والمحاولة مجددًا',
'something_wrong': 'حدث خطأ ما',
    'google_account': 'حساب Google',
    'facebook_account': 'حساب Facebook',
    
  },

  'bn': {
    'welcome': 'PLAYMIXO-তে স্বাগতম',
    'home': 'হোম',
    'room': 'রুম',
    'game': 'গেম',
    'wallet': 'ওয়ালেট',
    'profile': 'প্রোফাইল',
    'setting': 'সেটিং',
    'privacy': 'গোপনীয়তা',
    'account': 'অ্যাকাউন্ট',
    'language': 'ভাষা',
    'help_center': 'সহায়তা কেন্দ্র',
    'logout': 'লগ আউট',
    'delete_account': 'অ্যাকাউন্ট মুছুন',
    'change_email': 'ইমেইল পরিবর্তন করুন',
'change_password': 'পাসওয়ার্ড পরিবর্তন করুন',
'account_information': 'অ্যাকাউন্টের তথ্য',
'linked_accounts': 'সংযুক্ত অ্যাকাউন্ট',
    'name': 'নাম',
'email': 'ইমেইল',
'mobile_number': 'মোবাইল নম্বর',
'uid': 'ইউআইডি',
    'new_email': 'নতুন ইমেইল',
'verification_email_sent': 'যাচাইকরণ ইমেইল পাঠানো হয়েছে। আপনার নতুন ইমেইল যাচাই করুন।',
    'new_password': 'নতুন পাসওয়ার্ড',
'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন',
'password_changed': 'পাসওয়ার্ড সফলভাবে পরিবর্তন করা হয়েছে',
'passwords_not_match': 'পাসওয়ার্ড মিলছে না',
    'faq': 'প্রায়শই জিজ্ঞাসিত প্রশ্ন',
'contact_support': 'সাপোর্টে যোগাযোগ করুন',
'report_problem': 'সমস্যা রিপোর্ট করুন',
'logout_confirm': 'আপনি কি সত্যিই লগ আউট করতে চান?',
'yes': 'হ্যাঁ',
'no': 'না',
'delete_confirm': 'আপনি কি সত্যিই আপনার অ্যাকাউন্ট স্থায়ীভাবে মুছে ফেলতে চান?',
'permanent_action': 'এই কাজটি স্থায়ী।',
'delete_password_message': 'আপনার অ্যাকাউন্ট স্থায়ীভাবে মুছতে পাসওয়ার্ড লিখুন।',
'password': 'পাসওয়ার্ড',
'delete_permanently': 'অ্যাকাউন্ট স্থায়ীভাবে মুছুন',
'please_enter_password': 'অনুগ্রহ করে আপনার পাসওয়ার্ড লিখুন',
'incorrect_password': 'ভুল পাসওয়ার্ড',
'login_again': 'অনুগ্রহ করে আবার লগ ইন করে চেষ্টা করুন',
'something_wrong': 'কিছু ভুল হয়েছে',
    'google_account': 'Google অ্যাকাউন্ট',
    'facebook_account': 'Facebook অ্যাকাউন্ট',
  },

  'tr': {
    'welcome': 'PLAYMIXO’ya Hoş Geldiniz',
    'home': 'Ana Sayfa',
    'room': 'Oda',
    'game': 'Oyun',
    'wallet': 'Cüzdan',
    'profile': 'Profil',
    'setting': 'Ayarlar',
    'privacy': 'Gizlilik',
    'account': 'Hesap',
    'language': 'Dil',
    'help_center': 'Yardım Merkezi',
    'logout': 'Çıkış Yap',
    'delete_account': 'Hesabı Sil',
    'change_email': 'E-postayı Değiştir',
'change_password': 'Şifreyi Değiştir',
'account_information': 'Hesap Bilgileri',
'linked_accounts': 'Bağlı Hesaplar',
    'name': 'Ad',
'email': 'E-posta',
'mobile_number': 'Cep Numarası',
'uid': 'UID',
    'new_email': 'Yeni E-posta',
'verification_email_sent': 'Doğrulama e-postası gönderildi. Lütfen yeni e-postanızı doğrulayın.',
    'new_password': 'Yeni Şifre',
'confirm_password': 'Şifreyi Onayla',
'password_changed': 'Şifre başarıyla değiştirildi',
'passwords_not_match': 'Şifreler eşleşmiyor',
    'faq': 'Sık Sorulan Sorular',
'contact_support': 'Destek ile İletişime Geç',
'report_problem': 'Sorun Bildir',
'logout_confirm': 'Çıkış yapmak istediğinizden emin misiniz?',
'yes': 'Evet',
'no': 'Hayır',
'delete_confirm': 'Hesabınızı kalıcı olarak silmek istediğinizden emin misiniz?',
'permanent_action': 'Bu işlem kalıcıdır.',
'delete_password_message': 'Hesabınızı kalıcı olarak silmek için şifrenizi girin.',
'password': 'Şifre',
'delete_permanently': 'Hesabı Kalıcı Olarak Sil',
'please_enter_password': 'Lütfen şifrenizi girin',
'incorrect_password': 'Yanlış şifre',
'login_again': 'Lütfen tekrar giriş yapın ve yeniden deneyin',
'something_wrong': 'Bir şeyler yanlış gitti',
    'google_account': 'Google Hesabı',
    'facebook_account': 'Facebook Hesabı',
  },

  'es': {
    'welcome': 'Bienvenido a PLAYMIXO',
    'home': 'Inicio',
    'room': 'Sala',
    'game': 'Juego',
    'wallet': 'Billetera',
    'profile': 'Perfil',
    'setting': 'Configuración',
    'privacy': 'Privacidad',
    'account': 'Cuenta',
    'language': 'Idioma',
    'help_center': 'Centro de ayuda',
    'logout': 'Cerrar sesión',
    'delete_account': 'Eliminar cuenta',
    'change_email': 'Cambiar correo electrónico',
'change_password': 'Cambiar contraseña',
'account_information': 'Información de la cuenta',
'linked_accounts': 'Cuentas vinculadas',
    'name': 'Nombre',
'email': 'Correo electrónico',
'mobile_number': 'Número de móvil',
'uid': 'UID',
    'new_email': 'Nuevo correo electrónico',
'verification_email_sent': 'Se ha enviado un correo de verificación. Confirma tu nuevo correo electrónico.',
    'new_password': 'Nueva contraseña',
'confirm_password': 'Confirmar contraseña',
'password_changed': 'Contraseña cambiada correctamente',
'passwords_not_match': 'Las contraseñas no coinciden',
    'faq': 'Preguntas frecuentes',
'contact_support': 'Contactar con soporte',
'report_problem': 'Informar de un problema',
'logout_confirm': '¿Seguro que quieres cerrar sesión?',
'yes': 'Sí',
'no': 'No',
'delete_confirm': '¿Seguro que quieres eliminar tu cuenta permanentemente?',
'permanent_action': 'Esta acción es permanente.',
'delete_password_message': 'Introduce tu contraseña para eliminar permanentemente tu cuenta.',
'password': 'Contraseña',
'delete_permanently': 'Eliminar cuenta permanentemente',
'please_enter_password': 'Introduce tu contraseña',
'incorrect_password': 'Contraseña incorrecta',
'login_again': 'Inicia sesión de nuevo e inténtalo otra vez',
'something_wrong': 'Algo salió mal',
   'google_account': 'Cuenta de Google', 
    'facebook_account': 'Cuenta de Facebook',
  },


  'fr': {
    'welcome': 'Bienvenue sur PLAYMIXO',
    'home': 'Accueil',
    'room': 'Salon',
    'game': 'Jeu',
    'wallet': 'Portefeuille',
    'profile': 'Profil',
    'setting': 'Paramètres',
    'privacy': 'Confidentialité',
    'account': 'Compte',
    'language': 'Langue',
    'help_center': 'Centre d’aide',
    'logout': 'Se déconnecter',
    'delete_account': 'Supprimer le compte',
    'change_email': 'Modifier l’e-mail',
'change_password': 'Modifier le mot de passe',
'account_information': 'Informations du compte',
'linked_accounts': 'Comptes liés',
    'name': 'Nom',
'email': 'E-mail',
'mobile_number': 'Numéro de mobile',
'uid': 'UID',
    'new_email': 'Nouvel e-mail',
'verification_email_sent': 'L’e-mail de vérification a été envoyé. Veuillez confirmer votre nouvel e-mail.',
    'new_password': 'Nouveau mot de passe',
'confirm_password': 'Confirmer le mot de passe',
'password_changed': 'Mot de passe modifié avec succès',
'passwords_not_match': 'Les mots de passe ne correspondent pas',
    'faq': 'Questions fréquentes',
'contact_support': 'Contacter le support',
'report_problem': 'Signaler un problème',
'logout_confirm': 'Voulez-vous vraiment vous déconnecter ?',
'yes': 'Oui',
'no': 'Non',
'delete_confirm': 'Voulez-vous vraiment supprimer définitivement votre compte ?',
'permanent_action': 'Cette action est définitive.',
'delete_password_message': 'Entrez votre mot de passe pour supprimer définitivement votre compte.',
'password': 'Mot de passe',
'delete_permanently': 'Supprimer définitivement le compte',
'please_enter_password': 'Veuillez saisir votre mot de passe',
'incorrect_password': 'Mot de passe incorrect',
'login_again': 'Veuillez vous reconnecter et réessayer',
'something_wrong': 'Une erreur est survenue',
    'google_account': 'Compte Google',
    'facebook_account': 'Compte Facebook',
  },

  'id': {
    'welcome': 'Selamat Datang di PLAYMIXO',
    'home': 'Beranda',
    'room': 'Ruangan',
    'game': 'Permainan',
    'wallet': 'Dompet',
    'profile': 'Profil',
    'setting': 'Pengaturan',
    'privacy': 'Privasi',
    'account': 'Akun',
    'language': 'Bahasa',
    'help_center': 'Pusat Bantuan',
    'logout': 'Keluar',
    'delete_account': 'Hapus Akun',
    'change_email': 'Ubah Email',
'change_password': 'Ubah Kata Sandi',
'account_information': 'Informasi Akun',
'linked_accounts': 'Akun Terhubung',
    'name': 'Nama',
'email': 'Email',
'mobile_number': 'Nomor Ponsel',
'uid': 'UID',
    'new_email': 'Email Baru',
'verification_email_sent': 'Email verifikasi telah dikirim. Silakan verifikasi email baru Anda.',
    'new_password': 'Kata Sandi Baru',
'confirm_password': 'Konfirmasi Kata Sandi',
'password_changed': 'Kata sandi berhasil diubah',
'passwords_not_match': 'Kata sandi tidak cocok',
    'faq': 'Pertanyaan yang Sering Diajukan',
'contact_support': 'Hubungi Dukungan',
'report_problem': 'Laporkan Masalah',
'logout_confirm': 'Apakah Anda yakin ingin keluar?',
'yes': 'Ya',
'no': 'Tidak',
'delete_confirm': 'Apakah Anda yakin ingin menghapus akun secara permanen?',
'permanent_action': 'Tindakan ini permanen.',
'delete_password_message': 'Masukkan kata sandi untuk menghapus akun secara permanen.',
'password': 'Kata Sandi',
'delete_permanently': 'Hapus Akun Secara Permanen',
'please_enter_password': 'Silakan masukkan kata sandi Anda',
'incorrect_password': 'Kata sandi salah',
'login_again': 'Silakan masuk lagi dan coba kembali',
'something_wrong': 'Terjadi kesalahan',
    'google_account': 'Akun Google',
    'facebook_account': 'Akun Facebook',
  },

  'pt': {
    'welcome': 'Bem-vindo ao PLAYMIXO',
    'home': 'Início',
    'room': 'Sala',
    'game': 'Jogo',
    'wallet': 'Carteira',
    'profile': 'Perfil',
    'setting': 'Configurações',
    'privacy': 'Privacidade',
    'account': 'Conta',
    'language': 'Idioma',
    'help_center': 'Central de Ajuda',
    'logout': 'Sair',
    'delete_account': 'Excluir conta',
    'change_email': 'Alterar e-mail',
'change_password': 'Alterar senha',
'account_information': 'Informações da conta',
'linked_accounts': 'Contas vinculadas',
    'name': 'Nome',
'email': 'E-mail',
'mobile_number': 'Número de celular',
'uid': 'UID',
    'new_email': 'Novo e-mail',
'verification_email_sent': 'O e-mail de verificação foi enviado. Confirme seu novo e-mail.',
    'new_password': 'Nova senha',
'confirm_password': 'Confirmar senha',
'password_changed': 'Senha alterada com sucesso',
'passwords_not_match': 'As senhas não coincidem',
    'faq': 'Perguntas frequentes',
'contact_support': 'Contactar o suporte',
'report_problem': 'Comunicar um problema',
'logout_confirm': 'Tem certeza de que deseja sair?',
'yes': 'Sim',
'no': 'Não',
'delete_confirm': 'Tem certeza de que deseja excluir sua conta permanentemente?',
'permanent_action': 'Esta ação é permanente.',
'delete_password_message': 'Digite sua senha para excluir sua conta permanentemente.',
'password': 'Senha',
'delete_permanently': 'Excluir conta permanentemente',
'please_enter_password': 'Digite sua senha',
'incorrect_password': 'Senha incorreta',
'login_again': 'Faça login novamente e tente outra vez',
'something_wrong': 'Algo deu errado',
    'google_account': 'Conta do Google',
    'facebook_account': 'Conta do Facebook',
  },
};

static String text(String languageCode, String key) {
  return _translations[languageCode]?[key] ??
      _translations['en']?[key] ??
      key;
}
}
String tr(String key) {
return PlaymixoTranslations.text(
  playmixoLanguageCode.value,
  key,
);
}

class PlaymixoSplash extends StatefulWidget {
  const PlaymixoSplash({super.key});

  @override
  State<PlaymixoSplash> createState() => _PlaymixoSplashState();
}

class _PlaymixoSplashState extends State<PlaymixoSplash> {
  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();

  Future.delayed(const Duration(seconds: 2), () {
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user != null
            ? const MainScreen()
            : const AuthPage(),
      ),
    );
  });
  }

  Future<void> _loadSavedLanguage() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return;

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = snapshot.data();
    final language = data?['language'];

    if (language is String && language.isNotEmpty) {
      playmixoLanguageCode.value = language;
    }
  } catch (_) {
    // Keep English if language cannot be loaded.
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: darkGold,
                boxShadow: [
                  BoxShadow(
                    color: darkGold.withOpacity(0.35),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PLAYMIXO',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                color: darkGold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'PLAY • CONNECT • ENJOY',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const PlaymixoApp());
}

/* ================= COLORS ================= */

const gold = Color(0xFFD4AF37);
const darkGold = Color(0xFFB28A18);
const black = Color(0xFF111111);
const bg = Color(0xFFF6F6F4);

/* ================= APP ================= */
class PlaymixoApp extends StatelessWidget {
  const PlaymixoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: playmixoLanguageCode,
      builder: (context, language, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Playmixo',
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: bg,
            fontFamily: 'Roboto',
            colorScheme: ColorScheme.fromSeed(
              seedColor: gold,
              brightness: Brightness.light,
            ),
          ),
          home: const PlaymixoSplash(),
        );
      },
    );
  }
}
/* ================= AUTH PAGE ================= */

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool otpSent = false;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController otpController = TextEditingController();

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

bool obscurePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
void initState() {
  super.initState();
  _initializeGoogleSignIn();
}

Future<void> _initializeGoogleSignIn() async {
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '249099517156-74c82t7gorpot3fdd6dhtv7apk893ral.apps.googleusercontent.com',
  );
}

  String? verificationId;
  int? resendToken;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String getPhoneNumber() {
    String phone = phoneController.text.trim();

    // Remove spaces, dashes and brackets.
    phone = phone.replaceAll(' ', '');
    phone = phone.replaceAll('-', '');
    phone = phone.replaceAll('(', '');
    phone = phone.replaceAll(')', '');

    return phone;
  }

  Future<void> sendOtp() async {
    final phoneNumber = getPhoneNumber();

    if (phoneNumber.isEmpty) {
      showMessage('Please enter your phone number');
      return;
    }

    if (!phoneNumber.startsWith('+')) {
      showMessage(
        'Please enter your phone number with country code, e.g. +971501234567',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);

            if (!mounted) return;

            setState(() {
              isLoading = false;
              otpSent = true;
            });

            showMessage('Phone number verified successfully');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MainScreen(),
              ),
            );
          } on FirebaseAuthException catch (e) {
            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            showMessage(
              e.message ?? 'Authentication failed',
            );
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          if (e.code == 'invalid-phone-number') {
            showMessage('The phone number is invalid');
          } else if (e.code == 'too-many-requests') {
            showMessage(
              'Too many requests. Please try again later.',
            );
          } else {
            showMessage(
              e.message ?? 'Failed to send OTP',
            );
          }
        },

        codeSent: (
          String verificationIdValue,
          int? resendTokenValue,
        ) {
          if (!mounted) return;

          setState(() {
            verificationId = verificationIdValue;
            resendToken = resendTokenValue;
            otpSent = true;
            isLoading = false;
          });

          showMessage('OTP sent successfully');
        },

        codeAutoRetrievalTimeout: (String verificationIdValue) {
          verificationId = verificationIdValue;
        },

        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Something went wrong. Please try again.');
    }
  }

Future<void> createAccount() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;

  if (name.isEmpty) {
    showMessage('Please enter your name');
    return;
  }

  if (email.isEmpty) {
    showMessage('Please enter your Gmail');
    return;
  }

  if (password.isEmpty) {
    showMessage('Please enter your password');
    return;
  }

  if (password.length < 6) {
    showMessage('Password must be at least 6 characters');
    return;
  }

  FocusScope.of(context).unfocus();

  setState(() {
    isLoading = true;
  });

  try {
    final userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception('User creation failed');
    }

    await user.updateDisplayName(name);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'name': name,
      'email': email,
      'phone': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (e.code == 'email-already-in-use') {
      showMessage('This email is already registered');
    } else if (e.code == 'invalid-email') {
      showMessage('Please enter a valid Gmail');
    } else if (e.code == 'weak-password') {
      showMessage('Password is too weak');
    } else {
      showMessage(e.message ?? 'Account creation failed');
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage('Account creation failed. Please try again.');
  }
}


Future<void> loginUser() async {
  if (isLoading) return;

  final email = emailController.text.trim();
  final password = passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    showMessage('Email and password are required.');
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Login failed');
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    String message;

    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        message = 'Email or password is incorrect.';
        break;
      case 'invalid-email':
        message = 'Please enter a valid email.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;
      default:
        message = e.message ?? 'Login failed. Please try again.';
    }

    showMessage(message);
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage('Login failed. Please try again.');
  }
}



  

  
  Future<void> continueToApp() async {
  final smsCode = otpController.text.trim();

  if (smsCode.isEmpty) {
    showMessage('Please enter OTP');
    return;
  }

  if (smsCode.length != 6) {
    showMessage('Please enter the 6-digit OTP');
    return;
  }

  if (verificationId == null) {
    showMessage('Please request a new OTP');
    return;
  }

  FocusScope.of(context).unfocus();

  setState(() {
    isLoading = true;
  });

  try {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'phone': user.phoneNumber ?? '',
        'name': nameController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (e.code == 'invalid-verification-code') {
      showMessage('Invalid OTP. Please check the code.');
    } else if (e.code == 'session-expired') {
      showMessage('OTP expired. Please request a new OTP.');
    } else {
      showMessage(
        e.message ?? 'Verification failed',
      );
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage('Verification failed. Please try again.');
  }
}

Future<void> demoSocialLogin(String provider) async {
  if (provider != 'Google') {
    showMessage(
      '$provider authentication will be connected next.',
    );
    return;
  }

  if (isLoading) return;

  setState(() {
    isLoading = true;
  });

  try {
    final googleSignIn = GoogleSignIn.instance;
    await _initializeGoogleSignIn();

    // Do NOT sign out before authentication.
    // This can trigger Account reauth failed [16].
    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final idToken = googleAuth.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Google ID token was not returned');
    }

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Firebase Google sign-in failed');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'phone': user.phoneNumber ?? '',
      'photoURL': user.photoURL ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage(
      e.message ?? 'Google sign-in failed',
    );
  } on GoogleSignInException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    debugPrint('GOOGLE ERROR CODE: ${e.code}');
    debugPrint('GOOGLE ERROR DESCRIPTION: ${e.description}');

    showMessage(
      'Google Error: ${e.code}\n${e.description ?? 'Unknown error'}',
    );
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    debugPrint('GOOGLE SIGN-IN ERROR: $e');

    showMessage(
      'Google sign-in failed. Please try again.',
    );
  }
}
  

InputDecoration fieldDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(
      icon,
      color: darkGold,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 17,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE0E0E0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE0E0E0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: darkGold,
        width: 2,
      ),
    ),
  );
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /* LOGO */

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: black,
                        border: Border.all(
                          color: darkGold,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'P',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: darkGold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PLAYMIXO',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                isLogin ? 'Welcome Back' : 'Create Account',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: black,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isLogin
                    ? 'Sign in to continue to Playmixo'
                    : 'Create your Playmixo account',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 28),

              /* LOGIN / SIGNUP SWITCH */

              Container(
                height: 52,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = true;
                            otpSent = false;
                            verificationId = null;
                            otpController.clear();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLogin ? black : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: isLogin ? darkGold : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = false;
                            otpSent = false;
                            verificationId = null;
                            otpController.clear();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isLogin ? black : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: !isLogin
                                  ? darkGold
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /* SIGN UP FIELDS */

if (!isLogin) ...[
  TextField(
    controller: nameController,
    textInputAction: TextInputAction.next,
    decoration: fieldDecoration(
      hint: 'Name',
      icon: Icons.person_outline,
    ),
  ),

  const SizedBox(height: 14),

  TextField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    decoration: fieldDecoration(
      hint: 'Gmail',
      icon: Icons.email_outlined,
    ),
  ),

  const SizedBox(height: 14),

  TextField(
    controller: passwordController,
    obscureText: obscurePassword,
    textInputAction: TextInputAction.done,
    decoration: fieldDecoration(
      hint: 'Password',
      icon: Icons.lock_outline,
    ).copyWith(
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscurePassword = !obscurePassword;
          });
        },
        icon: Icon(
          obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: darkGold,
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),

  SizedBox(
    height: 54,
    child: ElevatedButton(
      onPressed: isLoading ? null : createAccount,
      style: ElevatedButton.styleFrom(
        backgroundColor: black,
        disabledBackgroundColor: Colors.black54,
        foregroundColor: darkGold,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  darkGold,
                ),
              ),
            )
          : const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
    ),
  ),
],

/* PHONE LOGIN */

if (isLogin) ...[
  TextField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    decoration: fieldDecoration(
      hint: 'Gmail',
      icon: Icons.email_outlined,
    ),
  ),

  const SizedBox(height: 14),

  TextField(
    controller: passwordController,
    obscureText: obscurePassword,
    textInputAction: TextInputAction.done,
    decoration: fieldDecoration(
      hint: 'Password',
      icon: Icons.lock_outline,
    ).copyWith(
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscurePassword = !obscurePassword;
          });
        },
        icon: Icon(
          obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: darkGold,
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),

  SizedBox(
    height: 54,
    child: ElevatedButton(
      onPressed: isLoading ? null : loginUser,
      style: ElevatedButton.styleFrom(
        backgroundColor: black,
        disabledBackgroundColor: Colors.black54,
        foregroundColor: darkGold,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  darkGold,
                ),
              ),
            )
          : const Text(
              'Log In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
    ),
  ),
],

const SizedBox(height: 22),
              /* OR */

              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /* GOOGLE */

              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          demoSocialLogin('Google');
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const GoogleIcon(),
                      const SizedBox(width: 12),
                      Text(
                        isLogin
                            ? 'Continue with Google'
                            : 'Sign up with Google',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /* FACEBOOK */

              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          demoSocialLogin('Facebook');
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FacebookIcon(),
                      const SizedBox(width: 12),
                      Text(
                        isLogin
                            ? 'Continue with Facebook'
                            : 'Sign up with Facebook',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              /* CREATE ACCOUNT / LOGIN */

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? "Don't have an account?"
                        : 'Already have an account?',
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        otpSent = false;
                        verificationId = null;
                        otpController.clear();
                      });
                    },
                    child: Text(
                      isLogin ? 'Create New Account' : 'Log In',
                      style: const TextStyle(
                        color: darkGold,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'Secure phone verification powered by Firebase',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


                        


/* ================= GOOGLE ICON ================= */

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 25,
      height: 25,
      child: CustomPaint(
        painter: GoogleLogoPainter(),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  const GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      rect.deflate(3),
      -0.45,
      3.2,
      false,
      paint,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      rect.deflate(3),
      2.75,
      1.15,
      false,
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      rect.deflate(3),
      1.35,
      1.4,
      false,
      paint,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      rect.deflate(3),
      -2.9,
      1.1,
      false,
      paint,
    );

    final blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.50,
        size.height * 0.43,
        size.width * 0.42,
        4,
      ),
      blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/* ================= FACEBOOK ICON ================= */

class FacebookIcon extends StatelessWidget {
  const FacebookIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1877F2),
      ),
      alignment: Alignment.center,
      child: const Text(
        'f',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

/* ================= MAIN ================= */

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    RoomsPage(),
    GamePage(),
    WalletPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE8E8E8)),
          ),
        ),
        child: NavigationBar(
          height: 72,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: currentIndex,
          indicatorColor: const Color(0xFFF3E8B9),
          onDestinationSelected: (index) {
            setState(() => currentIndex = index);
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: black),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.meeting_room_outlined),
              selectedIcon: Icon(Icons.meeting_room, color: black),
              label: 'Room',
            ),
            const NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style, color: black),
              label: 'Game',
            ),
            const NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon:
                  Icon(Icons.account_balance_wallet, color: black),
              label: 'Wallet',
            ),

            NavigationDestination(
              icon: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: user == null
                    ? null
                    : _firestore
                        .collection('friend_requests')
                        .where('receiverId', isEqualTo: user.uid)
                        .where('status', isEqualTo: 'pending')
                        .snapshots(),
                builder: (context, snapshot) {
                  final hasPending = snapshot.data?.docs.isNotEmpty == true;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.person_outline),
                      if (hasPending)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              selectedIcon: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: user == null
                    ? null
                    : _firestore
                        .collection('friend_requests')
                        .where('receiverId', isEqualTo: user.uid)
                        .where('status', isEqualTo: 'pending')
                        .snapshots(),
                builder: (context, snapshot) {
                  final hasPending = snapshot.data?.docs.isNotEmpty == true;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.person, color: black),
                      if (hasPending)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              label: 'Profile',
            ),

            const NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: black),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= HOME ================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          Row(
            children: [
              const Text(
                '♛',
                style: TextStyle(
                  color: gold,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'Playmixo',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /* WELCOME */
          Container(
            height: 82,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gold, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 59,
                  height: 59,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: gold, width: 2),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'PLAYMIXO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: gold,
                  size: 28,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /* NEW EVENT */
          const HomeWideBox(
            title: 'New Event',
            subtitle: 'Special rewards and events are waiting!',
            visual: EventBoxVisual(),
            buttonText: 'Join Now',
          ),

          const SizedBox(height: 12),

          /* NEW BOARD */
          const HomeWideBox(
            title: 'New Board',
            subtitle: 'Playmixo Tash Board',
            visual: TashBoardVisual(),
            buttonText: 'Explore',
          ),

          const SizedBox(height: 12),

          /* NEW CARD */
          const HomeWideBox(
            title: 'New Card',
            subtitle: 'Realistic Tash Playing Cards',
            visual: TashCardsVisual(),
            buttonText: 'View Cards',
          ),

          const SizedBox(height: 12),

          /* NEW CARD BOX */
          const HomeWideBox(
            title: 'New Card Box',
            subtitle: 'Premium Tash Card Collection',
            visual: TashCardBoxVisual(),
            buttonText: 'Open Box',
          ),

          const SizedBox(height: 12),

          /* FREE REWARD */
          const HomeWideBox(
            title: 'Free Reward',
            subtitle: 'Open your free reward box',
            visual: RewardBoxVisual(),
            buttonText: 'Claim',
          ),

          const SizedBox(height: 12),

          /* DAILY TASK */
          const HomeWideBox(
            title: 'Daily Task',
            subtitle: 'Complete tasks and collect rewards',
            visual: DailyTaskBoxVisual(),
            buttonText: 'View Task',
          ),

          const SizedBox(height: 12),

          /* UPDATE */
          const HomeWideBox(
            title: 'Update',
            subtitle: 'Discover the latest Playmixo updates',
            visual: UpdateBoxVisual(),
            buttonText: 'View',
          ),

          const SizedBox(height: 16),

          Row(
            children: const [
              Text(
                'Featured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Spacer(),
              Text(
                'See All ›',
                style: TextStyle(
                  color: darkGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /* FEATURED */
          Container(
            height: 92,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lucky Spin Event',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Spin & Win Amazing Rewards!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 7),
                      SmallGoldButton(text: 'Join Now'),
                    ],
                  ),
                ),
                const Icon(
                  Icons.casino_rounded,
                  color: gold,
                  size: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= FULL WIDTH HOME BOX ================= */

class HomeWideBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget visual;
  final String buttonText;

  const HomeWideBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.visual,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124,
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFD8D0B8),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 7),
                SmallGoldButton(text: buttonText),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 115,
            height: 100,
            child: visual,
          ),
        ],
      ),
    );
  }
}

/* ================= REAL TASH BOARD ================= */

class TashBoardVisual extends StatelessWidget {
  const TashBoardVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 108,
        height: 82,
        decoration: BoxDecoration(
          color: const Color(0xFF17130D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF9C7727),
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF315B35),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xFFC5A34A),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 7,
                child: Container(
                  width: 25,
                  height: 17,
                  decoration: BoxDecoration(
                    color: const Color(0xFF234427),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: gold),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 7,
                child: Container(
                  width: 25,
                  height: 17,
                  decoration: BoxDecoration(
                    color: const Color(0xFF234427),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: gold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 34,
                  height: 27,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3922),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: gold),
                  ),
                  child: const Center(
                    child: Text(
                      'TASH',
                      style: TextStyle(
                        color: gold,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= REAL PLAYING CARDS ================= */

class TashCardsVisual extends StatelessWidget {
  const TashCardsVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 105,
        height: 86,
        child: Stack(
          children: [
            Positioned(
              left: 17,
              top: 8,
              child: Transform.rotate(
                angle: -0.18,
                child: const _RealCard(
                  number: 'A',
                  symbol: '♠',
                ),
              ),
            ),
            Positioned(
              left: 38,
              top: 3,
              child: Transform.rotate(
                angle: 0.02,
                child: const _RealCard(
                  number: 'K',
                  symbol: '♥',
                  red: true,
                ),
              ),
            ),
            Positioned(
              left: 59,
              top: 9,
              child: Transform.rotate(
                angle: 0.16,
                child: const _RealCard(
                  number: 'Q',
                  symbol: '♦',
                  red: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RealCard extends StatelessWidget {
  final String number;
  final String symbol;
  final bool red;

  const _RealCard({
    required this.number,
    required this.symbol,
    this.red = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 59,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFFBDB8AA),
        ),
        boxShadow: [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.35),
    blurRadius: 5,
    offset: Offset(2, 3),
  ),
],
      ),
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              color: red ? const Color(0xFF9D2525) : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                  color: red ? const Color(0xFF9D2525) : Colors.black,
                  fontSize: 23,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REAL TASH CARD BOX ================= */

class TashCardBoxVisual extends StatelessWidget {
  const TashCardBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 91,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF17130D),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFB18A32),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'PLAYMIXO',
                  style: TextStyle(
                    color: gold,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'TASH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'CARD COLLECTION',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 5,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            child: Container(
              width: 68,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFC49B3A),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REWARD BOX ================= */

class RewardBoxVisual extends StatelessWidget {
  const RewardBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 82,
            height: 63,
            decoration: BoxDecoration(
              color: const Color(0xFF18130D),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: gold,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.card_giftcard_rounded,
                color: gold,
                size: 38,
              ),
            ),
          ),
          Positioned(
            top: 1,
            child: Container(
              width: 74,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFF242018),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= DAILY TASK BOX ================= */

class DailyTaskBoxVisual extends StatelessWidget {
  const DailyTaskBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 88,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: gold,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.assignment_turned_in_rounded,
              color: gold,
              size: 32,
            ),
            SizedBox(height: 3),
            Text(
              'DAILY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= UPDATE BOX ================= */

class UpdateBoxVisual extends StatelessWidget {
  const UpdateBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90,
        height: 69,
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: gold,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.campaign_rounded,
              color: gold,
              size: 31,
            ),
            SizedBox(height: 3),
            Text(
              'UPDATE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= EVENT BOX ================= */

class EventBoxVisual extends StatelessWidget {
  const EventBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 91,
        height: 73,
        decoration: BoxDecoration(
          color: const Color(0xFF18130D),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: gold,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.card_giftcard_rounded,
            color: gold,
            size: 39,
          ),
        ),
      ),
    );
  }
}
          

              

/* ================= ROOMS ================= */

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Room',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
  icon: const Icon(Icons.search_rounded),
  onPressed: () {
    showSearch(
      context: context,
      delegate: UserSearchDelegate(),
    );
  },
),
              ],
            ),
          ),

          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  Container(
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const TabBar(
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                      ),
                      labelColor: gold,
                      unselectedLabelColor: Colors.black54,
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Popular'),
                        Tab(text: 'My Room'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        RoomList(),
                        RoomList(popular: true),
                        RoomList(myRoom: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomList extends StatelessWidget {
  final bool popular;
  final bool myRoom;

  const RoomList({
    super.key,
    this.popular = false,
    this.myRoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final rooms = [
      ('Tash Lovers', '128 online', Icons.style_rounded),
      ('Chill Zone', '95 online', Icons.workspace_premium_rounded),
      ('Friends Room', '76 online', Icons.groups_rounded),
      ('VIP Room', '54 online', Icons.emoji_events_rounded),
      ('Fun Time', '41 online', Icons.casino_rounded),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];

        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 61,
                height: 61,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: gold,
                    width: 1,
                  ),
                ),
                child: Icon(
                  room.$3,
                  color: gold,
                  size: 31,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myRoom
                          ? 'My ${room.$1}'
                          : room.$1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 14,
                          color: gold,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          room.$2,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.person_rounded,
                          size: 13,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '2 - 4 Players',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (popular || index == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8B9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        index == 1 ? 'Hot' : 'Popular',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    width: 58,
                    height: 27,
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Join',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}


class UserSearchDelegate extends SearchDelegate<String?> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sirf current search screen ke liye.
  // Send dabane ke baad button hide rahega.
  bool _requestSentInCurrentSearch = false;

  Future<Map<String, dynamic>?> _searchUser(String text) async {
    final searchId = text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(searchId)) {
      return null;
    }

    final doc = await _firestore
        .collection('public_user_ids')
        .doc(searchId)
        .get();

    if (!doc.exists) return null;

    final data = doc.data() ?? {};
    final uid = data['uid']?.toString() ?? '';

    if (uid.isEmpty) return null;

    return {
  'uid': uid,
  'userId': data['userId']?.toString() ?? searchId,
  'displayName': data['displayName']?.toString() ??
      data['name']?.toString() ??
      'Playmixo User',
  'photoURL': data['photoURL']?.toString() ?? '',
  'bio': data['bio']?.toString() ?? '',
};
  }

  Future<void> _sendRequest(
    String targetUid,
    BuildContext context,
  ) async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) return;

    if (currentUser.uid == targetUid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot send a request to yourself.'),
        ),
      );
      return;
    }

    try {
      final requestId = '${currentUser.uid}_$targetUid';

      await _firestore
          .collection('friend_requests')
          .doc(requestId)
          .set({
        'senderId': currentUser.uid,
        'receiverId': targetUid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Button isi search ke andar hide rahega.
      _requestSentInCurrentSearch = true;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Friend request sent.'),
          ),
        );

        // UI rebuild.
        showSuggestions(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not send request: $e'),
          ),
        );
      }
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';

            // Nayi search ke liye button state reset.
            _requestSentInCurrentSearch = false;

            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return const Center(
        child: Text('Enter 6-digit User ID'),
      );
    }

    if (!RegExp(r'^\d{6}$').hasMatch(query.trim())) {
      return const Center(
        child: Text('Enter exactly 6 digits'),
      );
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: _searchUser(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Search failed: ${snapshot.error}'),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const Center(
            child: Text('User not found.'),
          );
        }

        final uid = user['uid'].toString();
        final name = user['displayName'].toString();
        final userId = user['userId'].toString();
        final photoURL = user['photoURL'].toString();

        return Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE0E0E0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DP
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PublicProfilePage(
          userId: userId,
          name: name,
          photoURL: photoURL,
          bio: user['bio']?.toString() ?? '',
        ),
      ),
    );
  },
  child: CircleAvatar(
    radius: 42,
    backgroundImage: photoURL.isNotEmpty
        ? NetworkImage(photoURL)
        : null,
    child: photoURL.isEmpty
        ? const Icon(
            Icons.person,
            size: 42,
          )
        : null,
  ),
),

                const SizedBox(height: 12),

                // NAME
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // 6-DIGIT USER ID
                Text(
                  'ID: $userId',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // SEND REQUEST
                if (!_requestSentInCurrentSearch)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _sendRequest(
                        uid,
                        context,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(
                          color: Colors.black26,
                        ),
                      ),
                      child: const Text(
                        'Send Request',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}


        
      
        





/* ================= GAME ================= */

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 17, 18, 20),
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: gold,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Tash',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /* PLAY TASH HEADER */
          Container(
            height: 147,
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: gold,
                width: 1.4,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  left: 22,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 27,
                  ),
                ),
                const Positioned(
                  right: 22,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 27,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.style_rounded,
                        color: gold,
                        size: 40,
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Play Tash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Classic • Fun • Challenge',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Players',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: PlayerVisualCard(
                  title: '1 Player',
                  count: 1,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: PlayerVisualCard(
                  title: '2 Players',
                  count: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const PlayerVisualCard(
            title: '4 Players',
            count: 4,
          ),

          const SizedBox(height: 18),

          const Text(
            'Game Items',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
  children: [
    Expanded(
      child: GameVisualItem(
        title: 'Tash Card',
        visual: TashCardsVisual(),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: GameVisualItem(
        title: 'Board',
        visual: TashBoardVisual(),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: GameVisualItem(
        title: 'Box',
        visual: TashCardBoxVisual(),
      ),
    ),
  ],
),
        ],
      ),
    );
  }
}

class PlayerVisualCard extends StatelessWidget {
  final String title;
  final int count;

  const PlayerVisualCard({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0D6AD),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                count,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.person_rounded,
                    size: 25,
                    color: black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class GameVisualItem extends StatelessWidget {
  final String title;
  final Widget visual;

  const GameVisualItem({
    super.key,
    required this.title,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE0D6AD),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            child: Center(child: visual),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= WALLET ================= */
/* USER SAID DO NOT CHANGE */

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Wallet',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: const [
          WalletBalance(
            icon: Icons.monetization_on_rounded,
            title: 'Coins',
            value: '0',
          ),
          SizedBox(height: 14),
          WalletBalance(
            icon: Icons.diamond_rounded,
            title: 'Diamonds',
            value: '0',
          ),
        ],
      ),
    );
  }
}

class WalletBalance extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const WalletBalance({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: gold, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: black, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= PROFILE ================= */
class PublicProfilePage extends StatelessWidget {
  final String userId;
  final String name;
  final String photoURL;
  final String bio;

  const PublicProfilePage({
    super.key,
    required this.userId,
    required this.name,
    required this.photoURL,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: gold, width: 1.2),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 43,
                      backgroundColor: gold,
                      backgroundImage: photoURL.isNotEmpty
                          ? NetworkImage(photoURL)
                          : null,
                      child: photoURL.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: black,
                            )
                          : null,
                    ),
                    IgnorePointer(
                      child: Image.asset(
                        'assets/prime_frames/imperial_crown.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  name.isNotEmpty ? name : 'Playmixo User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  userId,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (bio.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                Container(
                  height: 1,
                  color: Colors.white24,
                ),

                const SizedBox(height: 18),

                const Row(
                  children: [
                    ProfileStat('Followers'),
                    ProfileStat('Following'),
                    ProfileStat('Gift Sent'),
                    ProfileStat('Gift Received'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
String profileFrame = 'Imperial Crown';
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String publicUserId = '';
  String bio = '';
  bool loadingProfile = true;
  bool uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }
Future<void> _pickAndUploadProfilePhoto() async {
  final user = _auth.currentUser;
  if (user == null || uploadingPhoto) return;

  try {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
  source: ImageSource.gallery,
  imageQuality: 90,
);

if (image == null) return;

setState(() {});

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Photo selected successfully!')),
);
} catch (e) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Photo selection failed: $e')),
  );
} finally {
  if (mounted) {
    setState(() => uploadingPhoto = false);
  }
  }
}
    
  Future<void> _loadProfileData() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() => loadingProfile = false);
      }
      return;
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final data = doc.data() ?? {};

      final savedBio = (data['bio'] ?? '').toString();

      String generatedUserId = '';

      try {
        generatedUserId = await _getOrCreatePublicUserId();
      } catch (_) {
        generatedUserId =
            (data['userId'] ?? '').toString();
      }

      if (!mounted) return;

      setState(() {
        publicUserId = generatedUserId;
        bio = savedBio;
        loadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        publicUserId = '';
        bio = '';
        loadingProfile = false;
      });
    }
  }

  Future<void> _copyUserId() async {
    if (publicUserId.isEmpty) return;

    await Clipboard.setData(
      ClipboardData(text: publicUserId),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User ID copied.'),
      ),
    );
  }

  void _open(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileFeaturePage(title: title),
      ),
    ).then((_) {
      _loadProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return AppPage(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: gold,
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: gold,
                      width: 3,
                    ),
                  ),
                  child: GestureDetector(
  onTap: uploadingPhoto ? null : _pickAndUploadProfilePhoto,
  child: Stack(
    alignment: Alignment.center,
    clipBehavior: Clip.none,
    children: [
      

      

      // PROFILE PHOTO
      CircleAvatar(
        radius: 43,
        backgroundColor: gold,
        backgroundImage: user?.photoURL != null
            ? NetworkImage(user!.photoURL!)
            : null,
        child: user?.photoURL == null
            ? const Icon(
                Icons.person,
                size: 50,
                color: black,
              )
            : null,
      ),

        

              // PRIME FRAME
      if (profileFrame == 'Imperial Crown')
        IgnorePointer(
          child: Image.asset(
            'assets/prime_frames/imperial_crown.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),


      

      if (uploadingPhoto)
        const CircularProgressIndicator(
          color: gold,
        ),
    ],
  ),
),
),

const SizedBox(height: 12),

Text(
                  user?.displayName?.isNotEmpty == true
                      ? user!.displayName!
                      : 'Playmixo User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                if (loadingProfile)
                  const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: gold,
                    ),
                  )
                else if (publicUserId.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        publicUserId,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: _copyUserId,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.copy_outlined,
                            size: 15,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ],
                  ),

                if (bio.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    bio,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                ],

                const SizedBox(height: 22),

                Container(
                  height: 1,
                  color: Colors.white24,
                ),

                const SizedBox(height: 18),

                const Row(
                  children: [
                    ProfileStat('Followers'),
                    ProfileStat('Following'),
                    ProfileStat('Gift Sent'),
                    ProfileStat('Gift Received'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const _ProfileSectionTitle('PROFILE CENTRE'),

          _ProfileMenuTile(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            subtitle: 'Username, profile photo and bio',
            onTap: () => _open(context, 'Edit Profile'),
          ),

          _ProfileMenuTile(
            icon: Icons.auto_awesome,
            title: 'Customization Centre',
            subtitle: 'Frames, themes and ornaments',
            onTap: () => _open(context, 'Customization Centre'),
          ),

          _ProfileMenuTile(
            icon: Icons.people_outline,
            title: 'Friends Centre',
            subtitle: 'Requests, friends, messages and blocked users',
            onTap: () => _open(context, 'Friends Centre'),
          ),

          _ProfileMenuTile(
            icon: Icons.card_giftcard,
            title: 'Gift Showcase',
            subtitle: 'Your gifts and collection',
            onTap: () => _open(context, 'Gift Showcase'),
          ),

          _ProfileMenuTile(
            icon: Icons.workspace_premium_outlined,
            title: 'Royal Badges & Achievements',
            subtitle: 'Your earned badges and achievements',
            onTap: () =>
                _open(context, 'Royal Badges & Achievements'),
          ),

          _ProfileMenuTile(
            icon: Icons.history,
            title: 'Profile Activity',
            subtitle: 'Visitors, followers and recent activity',
            onTap: () => _open(context, 'Profile Activity'),
          ),

          _ProfileMenuTile(
            icon: Icons.shield_outlined,
            title: 'Privacy & Safety',
            subtitle: 'Profile visibility and safety options',
            onTap: () => _open(context, 'Privacy & Safety'),
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;

  const ProfileStat(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            '0',
            style: TextStyle(
              color: gold,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  final String title;
  const _ProfileSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: darkGold,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: gold.withOpacity(0.18),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: black),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: black,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54, fontSize: 11),
        ),
        trailing: const Icon(Icons.chevron_right, color: darkGold),
        onTap: onTap,
      ),
    );
  }
}

class ProfileFeaturePage extends StatefulWidget {
  final String title;
  const ProfileFeaturePage({super.key, required this.title});

  @override
  State<ProfileFeaturePage> createState() => _ProfileFeaturePageState();
}

class _ProfileFeaturePageState extends State<ProfileFeaturePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String selectedFrame = 'Imperial Crown';
  String selectedTheme = 'Black Gold';
  String selectedOrnament = 'None';

  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

Future<void> _sendFriendRequest(String targetUid) async {
  final user = _auth.currentUser;

  if (user == null) {
    _message('Please sign in first.');
    return;
  }

  if (targetUid == user.uid) {
    _message('You cannot send a request to yourself.');
    return;
  }

  try {
    final requestId = '${user.uid}_$targetUid';

    await _firestore
        .collection('friend_requests')
        .doc(requestId)
        .set({
      'senderId': user.uid,
      'receiverId': targetUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    _message('Friend request sent.');
  } catch (e) {
    _message('Could not send friend request.');
  }
}

Future<void> _acceptFriendRequest(
  String requestId,
  String senderId,
) async {
  final user = _auth.currentUser;

  if (user == null) return;

  try {
    final batch = _firestore.batch();

    // Mere Friends mein sender
    final myFriendRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .doc(senderId);

    // Sender ke Friends mein main
    final senderFriendRef = _firestore
        .collection('users')
        .doc(senderId)
        .collection('friends')
        .doc(user.uid);

    batch.set(myFriendRef, {
      'uid': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    batch.set(senderFriendRef, {
      'uid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Request accepted
    final requestRef = _firestore
        .collection('friend_requests')
        .doc(requestId);

    batch.update(requestRef, {
      'status': 'accepted',
      'acceptedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    _message('Friend request accepted.');
  } catch (e) {
    _message('Could not accept request.');
  }
}

Future<void> _rejectFriendRequest(String requestId) async {
  try {
    await _firestore
        .collection('friend_requests')
        .doc(requestId)
        .update({
      'status': 'rejected',
      'rejectedAt': FieldValue.serverTimestamp(),
    });

    _message('Friend request rejected.');
  } catch (e) {
    _message('Could not reject request.');
  }
}

    
  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      final data = doc.data() ?? {};
      if (!mounted) return;
      usernameController.text =
          (data['displayName'] ?? user.displayName ?? '').toString();
      bioController.text = (data['bio'] ?? '').toString();
      selectedFrame = (data['profileFrame'] ?? 'Imperial Crown').toString();
      selectedTheme = (data['profileTheme'] ?? 'Black Gold').toString();
      selectedOrnament = (data['profileOrnament'] ?? 'None').toString();
      setState(() {});
    } catch (_) {
      // Profile can still be viewed if Firestore data is not available.
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      _message('Please sign in first.');
      return;
    }
    if (usernameController.text.trim().isEmpty) {
      _message('Please enter a username.');
      return;
    }

    setState(() => loading = true);
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'displayName': usernameController.text.trim(),
        'bio': bioController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updateDisplayName(usernameController.text.trim());
      if (!mounted) return;
      _message('Profile saved.');
    } catch (e) {
      _message('Could not save profile. Check Firestore rules.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _saveCustomization() async {
    final user = _auth.currentUser;
    if (user == null) {
      _message('Please sign in first.');
      return;
    }
    setState(() => loading = true);
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'profileFrame': selectedFrame,
        'profileTheme': selectedTheme,
        'profileOrnament': selectedOrnament,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      _message('Customization saved.');
    } catch (_) {
      _message('Could not save. Check Firestore rules.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

Future<void> _pickProfilePhoto() async {
  final picker = ImagePicker();
  final image = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 90,
  );

  if (image == null) return;

  final croppedImage = await ImageCropper().cropImage(
    sourcePath: image.path,
    aspectRatio: const CropAspectRatio(
      ratioX: 1,
      ratioY: 1,
    ),
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Profile Photo',
        lockAspectRatio: true,
      ),
    ],
  );

  if (croppedImage == null) return;

  if (!mounted) return;

  _message(
    'Photo selected. Profile photo storage will be connected later.',
  );
}

    void _message(String message) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

void _openChild(String title) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProfileFeaturePage(title: title),
    ),
  );
}
    
  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: darkGold,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _option({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: DropdownButtonFormField<String>(
        value: options.contains(value) ? value : options.first,
        decoration: InputDecoration(
          labelText: title,
          border: InputBorder.none,
        ),
        items: options
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
      ),
    );
  }

  Widget _action(String title, String subtitle, IconData icon,
      {VoidCallback? onTap}) {
    return _ProfileMenuTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap ?? () => _openChild(title),
    );
  }

  Widget _editProfile() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _heading('YOUR PROFILE INFORMATION'),
        TextField(
          controller: usernameController,
          maxLength: 30,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: bioController,
          maxLength: 160,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Bio',
            hintText: 'Write something about yourself',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        _action(
          'Change Profile Photo',
          'Photo upload will be connected in the next step',
          Icons.photo_camera_outlined,
          onTap: _pickProfilePhoto,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: black,
              foregroundColor: gold,
            ),
            onPressed: loading ? null : _saveProfile,
            child: loading
                ? const CircularProgressIndicator(color: gold)
                : const Text('SAVE PROFILE'),
          ),
        ),
      ],
    );
  }

  Widget _customization() {
  return ListView(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
    children: [
      // ================= PREMIUM HEADER =================
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF090909),
              Color(0xFF211807),
              Color(0xFF090909),
            ],
          ),
          border: Border.all(
            color: gold.withOpacity(.65),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: gold.withOpacity(.18),
              blurRadius: 22,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gold.withOpacity(.14),
                    border: Border.all(
                      color: gold.withOpacity(.55),
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CUSTOMIZATION CENTRE',
                        style: TextStyle(
                          color: gold,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Make your profile truly yours',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ================= LIVE PREVIEW =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(.07),
                    Colors.white.withOpacity(.02),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(.10),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'LIVE PROFILE PREVIEW',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFD76A),
                              Color(0xFF8F650D),
                              Color(0xFFFFE7A1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gold.withOpacity(.30),
                              blurRadius: 22,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF17130D),
                          border: Border.all(
                            color: gold,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: gold,
                          size: 52,
                        ),
                      ),

                      if (selectedOrnament != 'None')
                        Positioned(
                          top: -7,
                          child: Icon(
                            selectedOrnament == 'Crown'
                                ? Icons.workspace_premium
                                : selectedOrnament == 'Wings'
                                    ? Icons.flight
                                    : selectedOrnament == 'Dragon'
                                        ? Icons.local_fire_department
                                        : selectedOrnament == 'Flowers'
                                            ? Icons.local_florist
                                            : Icons.auto_awesome,
                            color: gold,
                            size: 31,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  Text(
                    usernameController.text.isEmpty
                        ? 'JANAN'
                        : usernameController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    selectedFrame,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '$selectedTheme  •  $selectedOrnament',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 24),

      _heading('PROFILE COLLECTIONS'),

      // ================= PRIME =================
      _customCollectionCard(
        icon: Icons.workspace_premium,
        title: 'PRIME',
        subtitle: 'Premium profile frames & royal looks',
        badge: 'PREMIUM',
        gradient: const [
          Color(0xFF3B2908),
          Color(0xFF080808),
        ],
        onTap: () => _openChild('Prime'),
      ),

      // ================= THEMES =================
      _customCollectionCard(
        icon: Icons.palette_outlined,
        title: 'THEMES',
        subtitle: 'Transform the look behind your profile',
        badge: 'COLLECTION',
        gradient: const [
          Color(0xFF281343),
          Color(0xFF090711),
        ],
        onTap: () => _openChild('Themes'),
      ),

      // ================= ORNAMENTS =================
      _customCollectionCard(
        icon: Icons.auto_awesome,
        title: 'ORNAMENTS',
        subtitle: 'Beautiful decorations around your profile',
        badge: 'ROYAL',
        gradient: const [
          Color(0xFF092A30),
          Color(0xFF070B0D),
        ],
        onTap: () => _openChild('Ornaments'),
      ),

      const SizedBox(height: 18),

      // ================= SAVE =================
      SizedBox(
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: black,
            foregroundColor: gold,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: gold.withOpacity(.65),
              ),
            ),
          ),
          onPressed: loading ? null : _saveCustomization,
          child: loading
              ? const CircularProgressIndicator(color: gold)
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline),
                    SizedBox(width: 9),
                    Text(
                      'APPLY & SAVE',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: .8,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ],
  );
}

Widget _customCollectionCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required String badge,
  required List<Color> gradient,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(23),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradient,
      ),
      border: Border.all(
        color: Colors.white.withOpacity(.10),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.18),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(23),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 57,
                height: 57,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: Colors.white.withOpacity(.08),
                  border: Border.all(
                    color: gold.withOpacity(.35),
                  ),
                ),
                child: Icon(
                  icon,
                  color: gold,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: .8,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: gold.withOpacity(.13),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: gold,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white38,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _friendsCentre() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _heading('FRIENDS CENTRE'),
        _action('Friend Requests', 'Accept or reject incoming requests',
            Icons.person_add_alt_1),
        _action('My Friends', 'View and search your friends', Icons.people),
        _action('Friend Messages', 'Open conversations with friends',
            Icons.chat_bubble_outline),
        _action('Blocked Users', 'View and unblock users', Icons.block),
      ],
    );
  }


Widget _friendRequests() {
  final user = _auth.currentUser;

  if (user == null) {
    return const Center(child: Text('Please sign in first.'));
  }

  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: _firestore
        .collection('friend_requests')
        .where('receiverId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'pending')
        
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
  return Center(
    child: Text('Error: ${snapshot.error}'),
  );
}

      final requests = snapshot.data?.docs ?? [];

      if (requests.isEmpty) {
        return const Center(
          child: Text('No pending friend requests.'),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          final senderId = (request.data()['senderId'] ?? '').toString();

          return FutureBuilder<
              QuerySnapshot<Map<String, dynamic>>>(
            future: _firestore
                .collection('public_user_ids')
                .where('uid', isEqualTo: senderId)
                .limit(1)
                .get(),
            builder: (context, profileSnapshot) {
              final profile =
                  profileSnapshot.data?.docs.isNotEmpty == true
                      ? profileSnapshot.data!.docs.first.data()
                      : <String, dynamic>{};

              final name = (profile['displayName'] ??
                      profile['name'] ??
                      'Playmixo User')
                  .toString();

              final userId = (profile['userId'] ?? '').toString();
              final photoURL = (profile['photoURL'] ?? '').toString();

              return Card(
                color: const Color(0xFF171717),
                child: ListTile(
                  leading: GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PublicProfilePage(
          userId: userId,
          name: name,
          photoURL: photoURL,
          bio: '',
        ),
      ),
    );
  },
  child: CircleAvatar(
    backgroundImage:
        photoURL.isNotEmpty ? NetworkImage(photoURL) : null,
    child: photoURL.isEmpty
        ? const Icon(Icons.person)
        : null,
  ),
),
                  title: Text(
                    name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    userId.isNotEmpty ? 'ID: $userId' : 'Wants to be your friend',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      TextButton(
                        onPressed: () =>
                            _rejectFriendRequest(request.id),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Reject'),
                      ),
                      TextButton(
                        onPressed: () =>
                            _acceptFriendRequest(request.id, senderId),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Accept'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}






    
  

  Widget _giftShowcase() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _heading('GIFT SHOWCASE'),
        _action('Favourite Gifts', 'Your selected favourite gifts',
            Icons.favorite_border),
        _action('Gift Collection', 'Gifts collected on your profile',
            Icons.card_giftcard),
        _action('Most Received', 'Your most received gifts',
            Icons.inventory_2_outlined),
        _action('Gift History', 'Sent and received gift history',
            Icons.history),
      ],
    );
  }

  Widget _badges() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _heading('ROYAL BADGES & ACHIEVEMENTS'),
        _action('VIP Level', 'Your current VIP level', Icons.workspace_premium),
        _action('Gift Champion', 'Gift-related achievements', Icons.emoji_events),
        _action('Popular Member', 'Popularity achievements', Icons.star_outline),
        _action('Loyal Member', 'Membership achievements', Icons.loyalty),
        _action('Event Winner', 'Event achievements', Icons.military_tech),
        _action('Friendship Badge', 'Friendship achievements', Icons.handshake),
        const SizedBox(height: 8),
        const Text(
          'Only earned badges should appear here. Badge records are not connected yet.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _activity() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _heading('PROFILE ACTIVITY'),
        _action('Recent Profile Visitors', 'People who viewed your profile',
            Icons.visibility_outlined),
        _action('Recent Followers', 'Your latest followers',
            Icons.person_add_alt),
        _action('Recent Gifts', 'Gifts received recently', Icons.card_giftcard),
        _action('Friend Activity', 'Recent activity from friends',
            Icons.people_outline),
        const SizedBox(height: 8),
        const Text(
          'Activity lists will show data after the related Firebase features are connected.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _privacySafety() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _heading('PRIVACY & SAFETY'),
        _action('Profile Visibility', 'Public or private profile',
            Icons.visibility_outlined,
            onTap: () => _openChild('Profile Visibility')),
        _action('Who Can Message Me', 'Message permissions',
            Icons.message_outlined),
        _action('Friend Request Settings', 'Control who can request friendship',
            Icons.person_add_alt),
        _action('Online Status', 'Control online visibility',
            Icons.circle_outlined),
        _action('Blocked Users', 'Review and unblock users', Icons.block),
        _action('Report User', 'Report an account for review',
            Icons.flag_outlined),
        const SizedBox(height: 8),
        const Text(
          'Your existing Settings > Privacy page remains unchanged.',
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _featureContent() {
  switch (widget.title) {
    case 'Edit Profile':
      return _editProfile();

    case 'Customization Centre':
      return _customization();

    case 'Prime':
      return _primeCollection();
          
    case 'Themes':
      return _themeCollection();

    case 'Ornaments':
      return _ornamentCollection();

    case 'Friends Centre':
      return _friendsCentre();
      
      case 'Gift Showcase':
        return _giftShowcase();
      case 'Royal Badges & Achievements':
        return _badges();
      case 'Profile Activity':
        return _activity();
      case 'Privacy & Safety':
        return _privacySafety();
      case 'Friend Requests':
  return _friendRequests();

case 'My Friends':
  return _myFriends();

case 'Friend Messages':
  return _emptyFeature(
    'Friend Messages will be connected next.',
    Icons.chat_bubble_outline,
  );

case 'Blocked Users':
  return _emptyFeature(
    'Blocked Users will be connected next.',
    Icons.block,
  );
      case 'Profile Visibility':
        return _emptyFeature(
          'Use Settings > Privacy to change your current profile privacy setting.',
          Icons.visibility_outlined,
        );
      default:
        return _emptyFeature(
          'This section is ready for its Firebase feature connection.',
          Icons.construction_outlined,
        );
    }
  }

  Widget _emptyFeature(String message, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 55, color: darkGold),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: black,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }


Widget _myFriends() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Center(
      child: Text(
        'Please sign in first.',
        style: TextStyle(color: black),
      ),
    );
  }

  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('friends')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(
            'Could not load friends.',
            style: const TextStyle(color: black),
          ),
        );
      }

      final friends = snapshot.data?.docs ?? [];

      if (friends.isEmpty) {
        return _emptyFeature(
          'No friends yet.',
          Icons.people_outline,
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index].data();
          final friendUid = friend['uid']?.toString() ?? '';

          return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('public_user_ids')
                .where('uid', isEqualTo: friendUid)
                .limit(1)
                .get(),
            builder: (context, profileSnapshot) {
              if (!profileSnapshot.hasData ||
                  profileSnapshot.data!.docs.isEmpty) {
                return const SizedBox.shrink();
              }

              final profile =
                  profileSnapshot.data!.docs.first.data();

              final name =
                  (profile['displayName'] ??
                          profile['name'] ??
                          'Playmixo User')
                      .toString();

              final userId =
                  (profile['userId'] ?? '').toString();

              final photoURL =
                  (profile['photoURL'] ?? '').toString();

              final bio =
                  (profile['bio'] ?? '').toString();

              return Card(
                color: const Color(0xFF171717),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PublicProfilePage(
                            userId: userId,
                            name: name,
                            photoURL: photoURL,
                            bio: bio,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: photoURL.isNotEmpty
                          ? NetworkImage(photoURL)
                          : null,
                      child: photoURL.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'ID: $userId',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}




    
Widget _primeCollection() {
  final primeItems = [
    ('Imperial Crown', true),
    ('Royal Majesty', false),
    ('Golden Monarch', false),
    ('King’s Legacy', false),
    ('Queen’s Grace', false),
    ('Royal Dynasty', false),
    ('Crown Emperor', false),
    ('Velvet Royal', false),
    ('Royal Sovereign', false),
    ('Imperial Glory', false),
    ('Golden Throne', false),
    ('Royal Prestige', false),
    ('Crown of Valor', false),
    ('Majestic Prince', false),
    ('Majestic Princess', false),
    ('Royal Regent', false),
    ('Emperor’s Aura', false),
    ('Royal Empress', false),
    ('Crown Royale', false),
    ('Eternal Monarch', false),
    ('Diamond Majesty', false),
    ('Crystal Crown', false),
    ('Diamond Eclipse', false),
    ('Crystal Palace', false),
    ('Diamond Frost', false),
    ('Sapphire Crown', false),
    ('Emerald Majesty', false),
    ('Ruby Royale', false),
    ('Crystal Aura', false),
    ('Diamond Radiance', false),
    ('Pearl Dynasty', false),
    ('Crystal Empress', false),
    ('Diamond Mirage', false),
    ('Gemstone Glory', false),
    ('Frozen Diamond', false),
    ('Dragon Emperor', false),
    ('Crimson Dragon', false),
    ('Inferno Dragon', false),
    ('Golden Dragon', false),
    ('Shadow Dragon', false),
    ('Dragon Flame', false),
    ('Obsidian Dragon', false),
    ('Ancient Dragon', false),
    ('Dragon Sovereign', false),
    ('Hellfire Crown', false),
    ('Phoenix Inferno', false),
    ('Crimson Inferno', false),
    ('Eternal Flame', false),
    ('Darkfire King', false),
    ('Burning Dynasty', false),
    ('Angel Serenity', false),
    ('Divine Wings', false),
    ('Celestial Angel', false),
    ('Golden Angel', false),
    ('Heavenly Grace', false),
    ('Angelic Crown', false),
    ('Divine Majesty', false),
    ('Sacred Wings', false),
    ('Seraphic Glory', false),
    ('Eternal Angel', false),
    ('Galaxy Emperor', false),
    ('Cosmic Crown', false),
    ('Nebula Majesty', false),
    ('Stellar Royal', false),
    ('Universe Aura', false),
    ('Galactic Diamond', false),
    ('Cosmic Eclipse', false),
    ('Moonlit Galaxy', false),
    ('Astral Crown', false),
    ('Infinity Star', false),
    ('Rose Majesty', false),
    ('Golden Blossom', false),
    ('Pearl Garden', false),
    ('Royal Orchid', false),
    ('Velvet Rose', false),
    ('Crystal Blossom', false),
    ('Moonflower Grace', false),
    ('Golden Petals', false),
    ('Sakura Royale', false),
    ('Diamond Rose', false),
    ('Pearl Serenity', false),
    ('Luxury Bloom', false),
    ('Floral Empress', false),
    ('Enchanted Rose', false),
    ('Velvet Pearl', false),
    ('Shadow King', false),
    ('Black Emperor', false),
    ('Dark Sovereign', false),
    ('Midnight Warrior', false),
    ('Obsidian Crown', false),
    ('Phantom Lord', false),
    ('Black Dynasty', false),
    ('Nightfall King', false),
    ('Shadow Monarch', false),
    ('Iron Majesty', false),
    ('Dark Knight', false),
    ('Black Phoenix', false),
    ('Silent Warrior', false),
    ('Void Emperor', false),
    ('Ruthless Crown', false),
    ('Golden Phoenix', false),
    ('Golden Legend', false),
    ('VIP Majesty', false),
    ('Royal Fortune', false),
    ('Millionaire Crown', false),
    ('Golden Prestige', false),
    ('Luxury Emperor', false),
    ('Golden Legacy', false),
    ('Elite Sovereign', false),
    ('Platinum Royal', false),
    ('Golden Dynasty', false),
    ('Diamond VIP', false),
    ('Imperial Gold', false),
    ('Ultimate Crown', false),
    ('Prestige Royale', false),
    ('Festival Crown', false),
    ('Star Celebration', false),
    ('Royal Carnival', false),
    ('Celebration King', false),
    ('Golden Confetti', false),
    ('Firework Royale', false),
    ('Birthday Majesty', false),
    ('Love Festival', false),
    ('Dream Crown', false),
    ('Magic Celebration', false),
    ('Lucky Star', false),
    ('Sweet Royal', false),
    ('Rainbow Majesty', false),
    ('Dreamy Galaxy', false),
    ('Celebration Emperor', false),
  ];

  return Container(
    color: const Color(0xFF050505),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 30),
      children: [
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B0B0B),
              foregroundColor: gold,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: gold.withOpacity(.65),
                  width: 1,
                ),
              ),
            ),
            onPressed: loading ? null : _saveCustomization,
            child: loading
                ? const CircularProgressIndicator(color: gold)
                : const Text(
                    'APPLY PRIME',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 14),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: primeItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 18,
            childAspectRatio: .68,
          ),
          itemBuilder: (context, index) {
            final name = primeItems[index].$1;
            final isFree = primeItems[index].$2;
            final selected = selectedFrame == name;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedFrame = name;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _primeVisual(name),

                        if (selected)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF080808),
                                border: Border.all(
                                  color: gold,
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: gold,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? gold : Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    isFree ? 'FREE' : 'PREMIUM',
                    style: TextStyle(
                      color: isFree
                          ? Colors.greenAccent
                          : Colors.white38,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}



    


    Widget _primeVisual(String name) {
  if (name == 'Imperial Crown') {
    return Image.asset(
      'assets/prime_frames/imperial_crown.png',
      width: 155,
      height: 155,
      fit: BoxFit.contain,
    );
  }
  if (name == 'Royal Majesty') {
    return Image.asset(
      'assets/prime_frames/royal_majesty.png',
      width: 155,
      height: 155,
      fit: BoxFit.contain,
    );
  }
        
  Color outer1 = gold;
  Color outer2 = const Color(0xFF76500B);
  IconData centerIcon = Icons.person;
  List<Widget> decorations = [];

  if (name == 'Diamond') {
    outer1 = const Color(0xFFEAF7FF);
    outer2 = const Color(0xFF6798B8);
    centerIcon = Icons.diamond;
    decorations = [
      const Positioned(
        top: 1,
        child: Icon(
          Icons.auto_awesome,
          color: Colors.white,
          size: 15,
        ),
      ),
      const Positioned(
        bottom: 5,
        right: 3,
        child: Icon(
          Icons.auto_awesome,
          color: Color(0xFFBDEBFF),
          size: 12,
        ),
      ),
    ];
  } else if (name == 'Royal') {
    centerIcon = Icons.person;
    decorations = [
      const Positioned(
        top: -2,
        child: Icon(
          Icons.workspace_premium,
          color: Color(0xFFFFD76A),
          size: 24,
        ),
      ),
    ];
  } else if (name == 'Angel Wings') {
    centerIcon = Icons.person;
    decorations = [
      const Positioned(
        left: -8,
        child: Icon(
          Icons.flight,
          color: Color(0xFFFFEAC0),
          size: 28,
        ),
      ),
      const Positioned(
        right: -8,
        child: Icon(
          Icons.flight,
          color: Color(0xFFFFEAC0),
          size: 28,
        ),
      ),
    ];
  } else if (name == 'Dragon') {
    outer1 = const Color(0xFFFFB52E);
    outer2 = const Color(0xFF8B160C);
    centerIcon = Icons.person;
    decorations = [
      const Positioned(
        top: 0,
        right: 0,
        child: Icon(
          Icons.local_fire_department,
          color: Color(0xFFFF6B21),
          size: 23,
        ),
      ),
      const Positioned(
        bottom: 2,
        left: 0,
        child: Icon(
          Icons.local_fire_department,
          color: Color(0xFFD92A16),
          size: 17,
        ),
      ),
    ];
  } else if (name == 'VIP') {
    outer1 = const Color(0xFFFFE69A);
    outer2 = const Color(0xFF9B6A12);
    centerIcon = Icons.star_rounded;
    decorations = [
      const Positioned(
        top: 0,
        child: Text(
          'VIP',
          style: TextStyle(
            color: gold,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    ];
  } else if (name == 'Event') {
    outer1 = const Color(0xFFE7B6FF);
    outer2 = const Color(0xFF7540A3);
    centerIcon = Icons.celebration;
    decorations = [
      const Positioned(
        top: 1,
        left: 2,
        child: Icon(
          Icons.auto_awesome,
          color: Color(0xFFFFD76A),
          size: 15,
        ),
      ),
      const Positioned(
        bottom: 3,
        right: 2,
        child: Icon(
          Icons.auto_awesome,
          color: Color(0xFFE7B6FF),
          size: 15,
        ),
      ),
    ];
  }

  return SizedBox(
  width: 155,
  height: 155,
    child: Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                outer1,
                outer2,
                outer1,
                outer2,
                outer1,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: outer1.withOpacity(.28),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
        ),

        Container(
          width: 98,
          height: 98,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF090909),
            border: Border.all(
              color: Colors.white.withOpacity(.15),
              width: 1,
            ),
          ),
        ),

        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                outer1.withOpacity(.28),
                const Color(0xFF111111),
              ],
            ),
            border: Border.all(
              color: outer1.withOpacity(.75),
              width: 2,
            ),
          ),
          child: Icon(
            centerIcon,
            color: outer1,
            size: name == 'Diamond' ? 34 : 36,
          ),
        ),

        ...decorations,
      ],
    ),
  );
}
      
                  
      


Widget _themeCollection() {
  final themeItems = [
    ('Black Gold', Icons.dark_mode, true),
    ('Royal Theme', Icons.workspace_premium, false),
    ('Diamond Theme', Icons.diamond, false),
    ('Purple Galaxy', Icons.auto_awesome, false),
    ('Blue Ocean', Icons.water_drop, false),
    ('Crimson Night', Icons.nights_stay, false),
  ];

  return ListView(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
    children: [
      _heading('THEME COLLECTION'),

      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF281343),
              Color(0xFF090711),
            ],
          ),
          border: Border.all(
            color: gold.withOpacity(.55),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.palette_outlined,
              color: gold,
              size: 34,
            ),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THEMES',
                    style: TextStyle(
                      color: gold,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Transform the look behind your profile.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: themeItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .82,
        ),
        itemBuilder: (context, index) {
          final item = themeItems[index];
          final name = item.$1;
          final icon = item.$2;
          final isFree = item.$3;
          final selected = selectedTheme == name;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTheme = name;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selected
                      ? [
                          const Color(0xFF3D205E),
                          const Color(0xFF100B17),
                        ]
                      : [
                          const Color(0xFF171717),
                          const Color(0xFF0B0B0B),
                        ],
                ),
                border: Border.all(
                  color: selected
                      ? gold
                      : Colors.white.withOpacity(.09),
                  width: selected ? 1.6 : 1,
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isFree
                            ? Colors.green.withOpacity(.16)
                            : gold.withOpacity(.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFree ? 'FREE' : 'PAID',
                        style: TextStyle(
                          color: isFree
                              ? Colors.greenAccent
                              : gold,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6C3BAA),
                          Color(0xFF171020),
                        ],
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: gold,
                      size: 38,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isFree ? 'Available for you' : 'Premium Theme',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: selected
                          ? gold
                          : Colors.white.withOpacity(.07),
                    ),
                    child: Center(
                      child: Text(
                        selected ? 'SELECTED' : 'CHOOSE',
                        style: TextStyle(
                          color: selected ? black : Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      const SizedBox(height: 18),

      SizedBox(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: black,
            foregroundColor: gold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
              side: BorderSide(
                color: gold.withOpacity(.65),
              ),
            ),
          ),
          onPressed: loading ? null : _saveCustomization,
          child: loading
              ? const CircularProgressIndicator(color: gold)
              : const Text(
                  'APPLY THEME',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
        ),
      ),
    ],
  );
}


Widget _ornamentCollection() {
  final ornamentItems = [
    ('None', Icons.close, true),
    ('Royal Crown', Icons.workspace_premium, false),
    ('Diamond', Icons.diamond, false),
    ('Angel Wings', Icons.flight, false),
    ('Dragon', Icons.local_fire_department, false),
    ('Golden Flowers', Icons.local_florist, false),
    ('Royal Stars', Icons.star_rounded, false),
  ];

  return ListView(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
    children: [
      _heading('ORNAMENT COLLECTION'),

      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF092A30),
              Color(0xFF070B0D),
            ],
          ),
          border: Border.all(
            color: gold.withOpacity(.55),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: gold,
              size: 34,
            ),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORNAMENTS',
                    style: TextStyle(
                      color: gold,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add beautiful decorations around your profile.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ornamentItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .82,
        ),
        itemBuilder: (context, index) {
          final item = ornamentItems[index];
          final name = item.$1;
          final icon = item.$2;
          final isFree = item.$3;
          final selected = selectedOrnament == name;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedOrnament = name;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: selected
                      ? [
                          const Color(0xFF124650),
                          const Color(0xFF091316),
                        ]
                      : [
                          const Color(0xFF171717),
                          const Color(0xFF0B0B0B),
                        ],
                ),
                border: Border.all(
                  color: selected
                      ? gold
                      : Colors.white.withOpacity(.09),
                  width: selected ? 1.6 : 1,
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isFree
                            ? Colors.green.withOpacity(.16)
                            : gold.withOpacity(.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFree ? 'FREE' : 'PAID',
                        style: TextStyle(
                          color: isFree
                              ? Colors.greenAccent
                              : gold,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 94,
                        height: 94,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: gold.withOpacity(.45),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: gold.withOpacity(.15),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        icon,
                        color: gold,
                        size: 42,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    isFree ? 'Available for you' : 'Premium Ornament',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: selected
                          ? gold
                          : Colors.white.withOpacity(.07),
                    ),
                    child: Center(
                      child: Text(
                        selected ? 'SELECTED' : 'CHOOSE',
                        style: TextStyle(
                          color: selected ? black : Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      const SizedBox(height: 18),

      SizedBox(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: black,
            foregroundColor: gold,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
              side: BorderSide(
                color: gold.withOpacity(.65),
              ),
            ),
          ),
          onPressed: loading ? null : _saveCustomization,
          child: loading
              ? const CircularProgressIndicator(color: gold)
              : const Text(
                  'APPLY ORNAMENT',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
        ),
      ),
    ],
  );
}

    

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: widget.title,
      child: _featureContent(),
    );
  }
}

/* ================= SETTINGS ================= */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
  title: tr('setting'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SettingItem(
  Icons.lock_outline,
  tr('privacy'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PrivacyPage(),
      ),
    );
  },
),

SettingItem(
  Icons.person_outline,
  tr('account'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AccountPage(),
      ),
    );
  },
),



          SettingItem(
  Icons.help_outline,
  tr('help_center'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HelpCenterPage(),
      ),
    );
  },
),

          SettingItem(
  Icons.logout,
  tr('logout'),
  onTap: () {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tr('logout')),
          content: Text(
  tr('logout_confirm'),
),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(tr('no')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await FirebaseAuth.instance.signOut();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AuthPage(),
                  ),
                  (route) => false,
                );
              },
              child: Text(tr('yes')),
            ),
          ],
        );
      },
    );
  },
),

          SettingItem(
  Icons.delete_outline,
  tr('delete_account'),
  danger: true,
  onTap: () {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(tr('delete_account')),
content: Text(
  tr('delete_confirm'),
),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(tr('no')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeleteAccountPage(),
                  ),
                );
              },
              child: Text(tr('yes')),
            ),
          ],
        );
      },
    );
  },
),

        ],
      ),
    );
  }
}


/* ================= SETTING ITEM ================= */

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;
  final VoidCallback? onTap;

  const SettingItem(
    this.icon,
    this.title, {
    super.key,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3,
        ),
        leading: Icon(
          icon,
          color: danger ? Colors.red : darkGold,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: danger ? Colors.red : black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: Colors.black45,
        ),
      ),
    );
  }
}



  class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<Map<String, String>> languages = [
    {'title': 'English', 'code': 'en'},
    {'title': 'Urdu', 'code': 'ur'},
    {'title': 'Hindi', 'code': 'hi'},
    {'title': 'Arabic', 'code': 'ar'},
    {'title': 'Bengali', 'code': 'bn'},
    {'title': 'Turkish', 'code': 'tr'},
    {'title': 'Spanish', 'code': 'es'},
    {'title': 'French', 'code': 'fr'},
    {'title': 'Indonesian', 'code': 'id'},
    {'title': 'Portuguese', 'code': 'pt'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguageSettings();
  }

  Future<void> _loadLanguageSettings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snapshot.data();

      final language = data?['language'];
      final languageChange = data?['languageChangeEnabled'];

      if (language is String && language.isNotEmpty) {
        playmixoLanguageCode.value = language;
      }

      if (languageChange is bool) {
        playmixoLanguageChangeEnabled.value = languageChange;
      }
    } catch (_) {
      // Keep current local settings if Firestore fails.
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _toggleLanguageChange(bool value) async {
    playmixoLanguageChangeEnabled.value = value;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(
          {'languageChangeEnabled': value},
          SetOptions(merge: true),
        );
      } catch (_) {
        // Keep the local setting even if Firestore fails.
      }
    }
  }

  Future<void> _changeLanguage(String code) async {
    if (!playmixoLanguageChangeEnabled.value) return;

    playmixoLanguageCode.value = code;

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(
          {'language': code},
          SetOptions(merge: true),
        );
      } catch (_) {
        // Keep the language changed locally even if Firestore fails.
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: tr('language'),
      child: ValueListenableBuilder<bool>(
        valueListenable: playmixoLanguageChangeEnabled,
        builder: (context, languageEnabled, child) {
          return ValueListenableBuilder<String>(
            valueListenable: playmixoLanguageCode,
            builder: (context, selectedLanguage, child) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(
                        color: const Color(0xFFE5E5E5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          languageEnabled
                              ? Icons.language
                              : Icons.language_outlined,
                          color: languageEnabled
                              ? darkGold
                              : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Language Change',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: languageEnabled
                                  ? black
                                  : Colors.red,
                            ),
                          ),
                        ),
                        Switch(
                          value: languageEnabled,
                          activeThumbColor: gold,
                          onChanged: _toggleLanguageChange,
                        ),
                      ],
                    ),
                  ),

                  ...languages.map((language) {
                    final code = language['code']!;
                    final title = language['title']!;
                    final selected = selectedLanguage == code;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 11),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(
                          color: selected
                              ? darkGold
                              : const Color(0xFFE5E5E5),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        onTap: languageEnabled
                            ? () => _changeLanguage(code)
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 17,
                          vertical: 3,
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: languageEnabled
                                ? black
                                : Colors.black38,
                          ),
                        ),
                        trailing: Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected
                              ? darkGold
                              : Colors.black38,
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}





class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: tr('account'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SettingItem(
            Icons.email_outlined,
            tr('change_email'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangeEmailPage(),
                ),
              );
            },
          ),

          SettingItem(
            Icons.lock_outline,
            tr('change_password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordPage(),
                ),
              );
            },
          ),

          SettingItem(
            Icons.info_outline,
            tr('account_information'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountInformationPage(),
                ),
              );
            },
          ),

          SettingItem(
            Icons.link,
            tr('linked_accounts'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LinkedAccountsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


Future<String> _getOrCreatePublicUserId() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception('User is not signed in.');
  }

  final firestore = FirebaseFirestore.instance;
  final userRef = firestore.collection('users').doc(user.uid);

  final userSnapshot = await userRef.get();
  final userData = userSnapshot.data() ?? {};

  final existingId = userData['userId']?.toString() ?? '';

  final displayName =
      (userData['displayName']?.toString().isNotEmpty ?? false)
          ? userData['displayName'].toString()
          : (userData['name']?.toString().isNotEmpty ?? false)
              ? userData['name'].toString()
              : (user.displayName?.isNotEmpty ?? false)
                  ? user.displayName!
                  : 'Playmixo User';

  final name = userData['name']?.toString() ?? '';

  final photoURL =
      (userData['photoURL']?.toString().isNotEmpty ?? false)
          ? userData['photoURL'].toString()
          : (user.photoURL ?? '');

  final bio = userData['bio']?.toString() ?? '';

  final profileFrame =
      userData['profileFrame']?.toString() ?? 'Imperial Crown';

  Future<void> syncPublicProfile(String id) async {
    await firestore.collection('public_user_ids').doc(id).set({
      'uid': user.uid,
      'userId': id,
      'displayName': displayName,
      'name': name,
      'photoURL': photoURL,
      'bio': bio,
      'profileFrame': profileFrame,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  if (RegExp(r'^\d{6}$').hasMatch(existingId)) {
    await syncPublicProfile(existingId);
    return existingId;
  }

  final firstIdRef =
      firestore.collection('public_user_ids').doc('123456');

  final firstIdResult =
      await firestore.runTransaction<String>((transaction) async {
    final reservation = await transaction.get(firstIdRef);

    if (!reservation.exists) {
      transaction.set(firstIdRef, {
        'uid': user.uid,
        'userId': '123456',
        'displayName': displayName,
        'name': name,
        'photoURL': photoURL,
        'bio': bio,
        'profileFrame': profileFrame,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return '123456';
    }

    return '';
  });

  if (firstIdResult == '123456') {
    await userRef.set({
      'userId': '123456',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return '123456';
  }

  final random = Random();

  for (int attempt = 0; attempt < 30; attempt++) {
    final number = 100000 + random.nextInt(900000);
    final candidate = number.toString();

    if (candidate == '123456') continue;

    final idRef =
        firestore.collection('public_user_ids').doc(candidate);

    final result =
        await firestore.runTransaction<String>((transaction) async {
      final reservation = await transaction.get(idRef);

      if (reservation.exists) return '';

      transaction.set(idRef, {
        'uid': user.uid,
        'userId': candidate,
        'displayName': displayName,
        'name': name,
        'photoURL': photoURL,
        'bio': bio,
        'profileFrame': profileFrame,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return candidate;
    });

    if (result.isNotEmpty) {
      await userRef.set({
        'userId': result,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return result;
    }
  }

  throw Exception('Could not create a unique User ID.');
}







class AccountInformationPage extends StatefulWidget {
  const AccountInformationPage({super.key});

  @override
  State<AccountInformationPage> createState() =>
      _AccountInformationPageState();
}

class _AccountInformationPageState
    extends State<AccountInformationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool isLoading = true;

  String name = '';
  String email = '';
  String phone = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadAccountInformation();
  }

  Future<void> _loadAccountInformation() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snapshot.data();

      if (!mounted) return;

      final generatedUserId =
    await _getOrCreatePublicUserId();

if (!mounted) return;

setState(() {
  name = data?['name']?.toString() ?? '';
  email = user.email ?? '';
  phone = user.phoneNumber ?? '';
  userId = generatedUserId;
  isLoading = false;
});
    } catch (_) {
      if (!mounted) return;

      setState(() {
        email = user.email ?? '';
        phone = user.phoneNumber ?? '';
        userId = '';
        isLoading = false;
      });
    }
  }

  Widget _infoBox(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? 'Not available' : value,
            style: const TextStyle(
              color: black,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userIdBox(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  value.isEmpty ? 'Not available' : value,
                  style: const TextStyle(
                    color: black,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (value.isNotEmpty)
                IconButton(
                  tooltip: 'Copy',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.copy_outlined,
                    size: 18,
                    color: Colors.black54,
                  ),
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: value),
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User ID copied'),
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: tr('account_information'),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: gold,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                24,
              ),
              children: [
                _infoBox(tr('name'), name),
                _infoBox(tr('email'), email),
                _infoBox(tr('mobile_number'), phone),
                _userIdBox(tr('uid'), userId),
              ],
            ),
    );
  }
}





class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController emailController =
      TextEditingController();

  bool isLoading = false;

  Future<void> changeEmail() async {
    final newEmail = emailController.text.trim();

    if (newEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a new email'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await user.verifyBeforeUpdateEmail(newEmail);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      tr('verification_email_sent'),
    ),
  ),
);

      emailController.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to change email'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: tr('change_email'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
  labelText: tr('new_email'),
  border: const OutlineInputBorder(),
),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : changeEmail,
                child: isLoading
    ? const CircularProgressIndicator()
    : Text(tr('change_email')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> changePassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        tr('passwords_not_match'),
      ),
    ),
  );
  return;
}

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await user.updatePassword(password);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      tr('password_changed'),
    ),
  ),
);

      passwordController.clear();
      confirmPasswordController.clear();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Failed to change password',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: tr('change_password'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
  labelText: tr('new_password'),
  border: const OutlineInputBorder(),
),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
  labelText: tr('confirm_password'),
  border: const OutlineInputBorder(),
),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : changePassword,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(tr('change_password')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LinkedAccountsPage extends StatelessWidget {
  const LinkedAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppPage(
      title: tr('linked_accounts'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SettingItem(
            Icons.email_outlined,
            user?.email ?? tr('email'),
          ),
          SettingItem(
            Icons.phone_outlined,
            user?.phoneNumber ?? tr('mobile_number'),
          ),
          SettingItem(
            Icons.g_mobiledata,
            tr('google_account'),
          ),
          SettingItem(
  Icons.facebook,
  tr('facebook_account'),
),
        ],
      ),
    );
  }
}


class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Help Center',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SettingItem(
            Icons.question_answer_outlined,
            'FAQ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FAQPage(),
                ),
              );
            },
          ),

          SettingItem(
            Icons.support_agent_outlined,
            'Contact Support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ContactSupportPage(),
                ),
              );
            },
          ),

          SettingItem(
            Icons.report_problem_outlined,
            'Report Problem',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportProblemPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


/* ================= FAQ PAGE ================= */

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Frequently Asked Questions',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          _FAQItem(
            question: 'How do I create an account?',
            answer:
                'Create your account using the available sign-in options and complete your profile information.',
          ),

          _FAQItem(
            question: 'What are Coins?',
            answer:
                'Coins are the main in-app currency used for supported features and activities in Playmixo.',
          ),

          _FAQItem(
            question: 'What are Diamonds?',
            answer:
                'Diamonds are a separate in-app currency that can be used for supported premium features.',
          ),

          _FAQItem(
            question: 'How do I play the game?',
            answer:
                'Open the Game section, choose the available game, and follow the instructions shown on the game screen.',
          ),

          _FAQItem(
            question: 'How do Rooms work?',
            answer:
                'Rooms allow users to join and interact with other users in supported Playmixo activities.',
          ),

          _FAQItem(
            question: 'What is the Wallet?',
            answer:
                'The Wallet shows your Coins and Diamonds balance and related wallet activity.',
          ),

          _FAQItem(
            question: 'What are Gifts?',
            answer:
                'Gifts are in-app items that can be sent to other users where the feature is supported.',
          ),
        ],
      ),
    );
  }
}


/* ================= FAQ ITEM ================= */

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 17,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          17,
          0,
          17,
          17,
        ),
        title: Text(
          question,
          style: const TextStyle(
            color: black,
            fontWeight: FontWeight.w800,
          ),
        ),
        iconColor: darkGold,
        collapsedIconColor: Colors.black54,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/* ================= CONTACT SUPPORT PAGE ================= */

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() =>
      _ContactSupportPageState();
}

class _ContactSupportPageState
    extends State<ContactSupportPage> {
  final TextEditingController _controller =
      TextEditingController();

  bool isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendSupportRequest() async {
    final message = _controller.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write your message first.'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in first.'),
        ),
      );
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('support_requests')
          .add({
        'userId': user.uid,
        'email': user.email ?? '',
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'open',
      });

      if (!mounted) return;

      setState(() {
        isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your support request has been sent.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not send your support request.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Contact Support',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          4,
          16,
          24,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: const Color(0xFFE5E5E5),
                ),
              ),
              child: const Text(
                'If you need help, write your message below and our support team can review your request.',
                style: TextStyle(
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: _controller,
              maxLines: 7,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Write your message...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSending
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        52,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        isSending ? null : _sendSupportRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(
                        double.infinity,
                        52,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                    child: isSending
                        ? const SizedBox(
                            width: 21,
                            height: 21,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: gold,
                            ),
                          )
                        : const Text(
                            'Send',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/* ================= REPORT PROBLEM PAGE ================= */

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() =>
      _ReportProblemPageState();
}

class _ReportProblemPageState
    extends State<ReportProblemPage> {
  final TextEditingController _controller =
      TextEditingController();

  bool isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendProblemReport() async {
    final problem = _controller.text.trim();

    if (problem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the problem first.'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in first.'),
        ),
      );
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('problem_reports')
          .add({
        'userId': user.uid,
        'email': user.email ?? '',
        'problem': problem,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'open',
      });

      if (!mounted) return;

      setState(() {
        isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Problem report has been sent.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not send the problem report.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Report Problem',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          4,
          16,
          24,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: const Color(0xFFE5E5E5),
                ),
              ),
              child: const Text(
                'Describe the problem you are experiencing so it can be reviewed.',
                style: TextStyle(
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: _controller,
              maxLines: 7,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Describe the problem...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E5E5),
                  ),
                ),
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSending
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        52,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        isSending ? null : _sendProblemReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(
                        double.infinity,
                        52,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),
                    child: isSending
                        ? const SizedBox(
                            width: 21,
                            height: 21,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                              color: gold,
                            ),
                          )
                        : const Text(
                            'Send',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




          

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController passwordController =
      TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> deleteAccount() async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      tr('please_enter_password'),
    ),
  ),
);
return;
}

final user = FirebaseAuth.instance.currentUser;

if (user == null || user.email == null) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      await user.delete();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthPage(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = 'Failed to delete account';

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message = tr('incorrect_password');
      } else if (e.code == 'requires-recent-login') {
        message = tr('login_again');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
  content: Text(
    tr('something_wrong'),
  ),
),
      
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: tr('delete_account'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
  tr('permanent_action'),
  style: const TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.w900,
  ),
),
  const SizedBox(height: 8),
Text(
  tr('delete_password_message'),
  style: const TextStyle(
    color: Colors.black54,
    fontSize: 14,
  ),
),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: tr('password'),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : deleteAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
  tr('delete_permanently'),
  style: const TextStyle(
    fontWeight: FontWeight.w800,
  ),
)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

          

/* ================= PRIVACY PAGE ================= */

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool profileVisitors = false;
  bool privateProfile = false;
  bool doNotFollow = false;
  bool doNotSendRequest = false;
  bool onlineStatus = true;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snapshot.data();

      if (!mounted) return;

      setState(() {
        profileVisitors =
            data?['profileVisitors'] as bool? ?? false;

        privateProfile =
            data?['privateProfile'] as bool? ?? false;

        doNotFollow =
            data?['doNotFollow'] as bool? ?? false;

        doNotSendRequest =
            data?['doNotSendRequest'] as bool? ?? false;

        onlineStatus =
            data?['onlineStatus'] as bool? ?? true;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Privacy settings could not be loaded.',
          ),
        ),
      );
    }
  }

  Future<void> _savePrivacySetting(
    String field,
    bool value,
  ) async {
    final user = _auth.currentUser;

    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          field: value,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save privacy setting.',
          ),
        ),
      );
    }
  }

  Future<void> _changeSetting(
    String field,
    bool value,
  ) async {
    setState(() {
      switch (field) {
        case 'profileVisitors':
          profileVisitors = value;
          break;

        case 'privateProfile':
          privateProfile = value;
          break;

        case 'doNotFollow':
          doNotFollow = value;
          break;

        case 'doNotSendRequest':
          doNotSendRequest = value;
          break;

        case 'onlineStatus':
          onlineStatus = value;
          break;
      }
    });

    await _savePrivacySetting(
      field,
      value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: tr('privacy'),
      child: isLoading
    ? const Center(
        child: CircularProgressIndicator(
          color: gold,
        ),
      )
    : Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            24,
          ),
          children: [
                PrivacyOptionBox(
                  title: 'Profile Visitors',
                  value: profileVisitors,
                  onChanged: (value) {
                    _changeSetting(
                      'profileVisitors',
                      value,
                    );
                  },
                ),

                PrivacyOptionBox(
                  title: 'Private Profile',
                  value: privateProfile,
                  onChanged: (value) {
                    _changeSetting(
                      'privateProfile',
                      value,
                    );
                  },
                ),

                PrivacyOptionBox(
                  title: 'Do Not Follow',
                  value: doNotFollow,
                  onChanged: (value) {
                    _changeSetting(
                      'doNotFollow',
                      value,
                    );
                  },
                ),

                PrivacyOptionBox(
                  title: 'Do Not Send Request',
                  value: doNotSendRequest,
                  onChanged: (value) {
                    _changeSetting(
                      'doNotSendRequest',
                      value,
                    );
                  },
                ),

PrivacyOptionBox(
  title: 'Online Status',
  value: onlineStatus,
  onChanged: (value) {
    _changeSetting(
      'onlineStatus',
      value,
    );
  },
),
              ],
            ),
          ),
    );
  }
}


/* ================= PRIVACY OPTION BOX ================= */

class PrivacyOptionBox extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const PrivacyOptionBox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: black,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          PrivacySwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}


/* ================= CUSTOM PRIVACY SWITCH ================= */

class PrivacySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PrivacySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        curve: Curves.easeOut,
        width: 106,
        height: 46,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: value ? black : Colors.red,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: value ? black : Colors.red,
            width: 1.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(
                milliseconds: 180,
              ),
              curve: Curves.easeOut,
              alignment: value
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Align(
              alignment: value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  left: value ? 9 : 0,
                  right: value ? 0 : 9,
                ),
                child: Text(
                  value ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= COMMON ================= */

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 18, 17, 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: gold,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

/* ================= SMALL BUTTON ================= */

class SmallGoldButton extends StatelessWidget {
  final String text;

  const SmallGoldButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: gold,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: black,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
