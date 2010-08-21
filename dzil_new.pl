#!/usr/bin/env perl

use Modern::Perl;
use autodie;

use constant DIST_FILE    =>  'dist.ini';
use constant WEAVER_FILE  =>  'weaver.ini';


open  my $dist_fh, '<', DIST_FILE;
chomp(my @dist = <$dist_fh>);
close $dist_fh;

die "This module's dist file has already been processed!\n"  unless  @dist eq 6;


open  $dist_fh, '>', DIST_FILE;
say $dist_fh ';  Basic author info';
say $dist_fh join "\n", @dist[0..2];
say $dist_fh "version = 0.001\n";
say $dist_fh join "\n", @dist[3..4];
say $dist_fh <<'__END_TEXT';



; -- fetch & generate files
[GatherDir]
[CompileTests]
[MinimumPerl]
[CriticTests]
[HasVersionTests]
[MetaTests]
[MinimumVersionTests]
[PodCoverageTests]
;[PodSpellingTests]
[PodSyntaxTests]
[PortabilityTests]
[SynopsisTests]
[UnusedVarsTests]
;[ReadmeMarkdownFromPod]
[ReadmeFromPod]
[KwaliteeTests]


; -- remove some files
[PruneCruft]
[ManifestSkip]

; -- get prereqs
[AutoPrereq]

; -- munge files
[ExtraTests]
[PkgVersion]

; -- dynamic meta-information
[ExecDir]
[ShareDir]
[Bugtracker]
[Repository]
[MetaConfig]

; -- generate meta files
[License]
[ModuleBuild]
[InstallGuide]
[MetaYAML]
[MetaJSON]
[PodWeaver]
[Manifest] ; should come last

; -- release
[CheckChangeLog]
[CheckChangesTests]
[CheckChangesHasContent]
[Git::Check]
[TestRelease]
[ConfirmRelease]

; releaser
[UploadToCPAN]

[Git::Tag]
tag_format = release-%v

[Git::Commit / Commit_Changes]

[Git::Push]
push_to = origin
__END_TEXT
close $dist_fh;


open  my $weave_fh, '>', WEAVER_FILE;
say $weave_fh <<'__END_TEXT';
[@CorePrep]

[Name]
[Version]

[Region  / prelude]

[Generic / SYNOPSIS]
[Generic / DESCRIPTION]
[Generic / OVERVIEW]

[Generic / EXPORTS]

[Collect / ATTRIBUTES]
command = attr

[Collect / METHODS]
command = method

[Collect / FUNCTIONS]
command = func

[Leftovers]

[Region  / postlude]

[Authors]
[Support]
[Legal]


[-Transformer]
transformer = List
__END_TEXT
