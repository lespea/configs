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



[PodWeaver]
;   Inserts POD into my modules                   {usefull}

;[@Basic]
;   I don't like all of the modules this provides so I'll just comment out the ones I dislike
[GatherDir]
;   Gathers file into build dir                 {required}
[PruneCruft]
;   Gets rid of useless garbage                 {usefull}
[ManifestSkip]
;   Uses MANIFEST.SKIP to skip files            {required}
[MetaYAML]
;   Creates Meta.yml file                       {required}
[License]
;   Creates license file                        {required}
;[Readme]
;   Basic readme                                {using ReadmeFromPod for now}
[ExtraTests]
;   Test anything in the xt directory           {usefull}
;[ExecDir]
;   Installs directory as exes                  {no exes as of yet}
;[ShareDir]
;   Installs dir content as ShareDir            {not sharing anything in this module}
;[MakeMaker]
;   Creates MakeMaker build script --           {MakeMaker is a POS so skip this}
[Manifest]
;   Creates Manifest file                       {required}
;[TestRelease]
;   Run tests before a release                  {Not using a release}
;[ConfirmRelease]
;   Confirm you want to release a dist          {Not using a release}
;[UploadToCPAN]
;   Uploads file to CPAN                        {Not uploading to CPAN so skip}


[MetaJSON]
;   Creates the new json meta file              {required}
[MinimumPerl]
;   Finds the bare minimum version of Perl      {usefull}


[ModuleBuild]
;   Creates Module::Build (build.pl)            {required}
;

[AutoPrereq]
;   Auto generate the prereqs                   {required}
;skip =

;MetaRecommends]
;   Adds "recommended" modules                  {not used for this module}
;ModuleName = 0

[CompileTests]
;   Makes sure everything compiles              {required}
[UnusedVarsTests]
;   Tests for any unused variables              {usefull}
[SynopsisTests]
;   Tests that all synopsis code blocks work    {usefull}
[PortabilityTests]
;   Tests that the filenames are OS portable    {usefull}
;[PodSpellingTests]
;   Tests spelling in all POD documentation     {not in PPM :@}
[CheckChangesTests]
;   Makes sure you have the current version in
;       the changelog                           {usefull}
[PodSyntaxTests]
[PodCoverageTests]
;   These two test for POD syntax and coverage  {usefull}

[InstallGuide]
;   Generates a generic install guide           {usefull}

;[ReadmeMarkdownFromPod]
;   Generates readme using markdown             {usefull}
[ReadmeFromPod]
;   Create useful readme                        {required}

[PerlCritic]


[Prepender]
;   Adds info to the top of your madules        {usefull}
line =
line = ################################################################################
line = #  For any technical difficulties, please file a bug report on CPAN or github  #
line = ################################################################################
line =
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
[Legal]


[-Transformer]
transformer = List
__END_TEXT
