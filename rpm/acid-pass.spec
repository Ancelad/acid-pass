#
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
#

Name:       harbour-acid-pass

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Shows stored WiFi passwords
Version:    0.1
Release:    0
Group:      Qt/Qt
License:    LICENSE
URL:        https://github.com/a-dekker/acid-pass
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Shows stored WiFi passwords


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5

%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}
%{_datadir}/%{name}/qml
%{_datadir}/%{name}/helper
%attr(700,root,root) %{_datadir}/%{name}/helper/acid-passhelper.sh
%attr(4755,root,root) %{_datadir}/%{name}/helper/acid-passhelper
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
%{_datadir}/icons/hicolor/108x108/apps/%{name}.png
%{_datadir}/icons/hicolor/128x128/apps/%{name}.png
%{_datadir}/icons/hicolor/256x256/apps/%{name}.png
/usr/bin
/usr/share/harbour-acid-pass
/usr/share/applications
/usr/share/icons/hicolor/86x86/apps
/usr/share/icons/hicolor/108x108/apps
/usr/share/icons/hicolor/128x128/apps
/usr/share/icons/hicolor/256x256/apps