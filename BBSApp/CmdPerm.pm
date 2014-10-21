package OurNet::BBSApp::CmdPerm;

# XXX: this module should split for each kind of isa/board/.
use strict;
use constant P_SYSBOT   => 0x01;
use constant P_ARENA    => 0x02;
use constant P_INVOLVED => 0x04;

my %cmdtable = (
    'cr_time'  => P_SYSBOT,
    'wg_time'  => P_ARENA|P_SYSBOT,
    'pp_time'  => P_ARENA|P_SYSBOT,
    'vt_time'  => P_ARENA|P_SYSBOT,
    'depend'   => P_INVOLVED,
    'wg_min'   => P_ARENA|P_SYSBOT,
    'involved' => P_INVOLVED|P_SYSBOT,
    'descr'    => P_ARENA|P_SYSBOT,
    'owner'    => P_SYSBOT,
    'issue'    => P_ARENA,
    'consensus'=> P_ARENA,
    'status'   => P_SYSBOT,
    'draft'    => P_INVOLVED|P_SYSBOT,
    'vote'     => P_INVOLVED|P_SYSBOT,
);

my %cmdmap = (
    '�Q�׮ɭ�' => 'wg_time', 'GatherTime' => 'wg_time',  '�׮�' => 'wg_time',
    '��׮ɭ�' => 'pp_time', 'DraftTime'  => 'pp_time',  '�׮�' => 'pp_time',
    '�벼�ɭ�' => 'vt_time', 'VoteTime'   => 'wg_time',  '����' => 'vt_time',
    '�����U��' => 'wg_min',  'Threshold'  => 'wg_min',   '�U��' => 'wg_min',
    '�s�W����' => 'involved','AddMember'  => 'involved', '�s�W' => 'involved',
    '�D������' => 'descr',   'Description'=> 'descr',    '�D��' => 'descr',
    '�촣ĳ�H' => 'owner',   'Originator' => 'owner',    '��ĳ' => 'owner',
    '�ثe�i��' => 'status',  'Status'     => 'status',   '�i��' => 'status',
    '�W�ׯ��' => 'draft',   'Draft'      => 'draft',    '���' => 'draft',
    '�i��벼' => 'vote',    'Vote'       => 'vote',     '�벼' => 'vote',
);

sub check {
    my ($who, $prop, $art, $cmd, $param) = @_;

    $_[3] = $cmd if (not exists $cmdtable{$cmd} and $cmd = $cmdmap{$cmd});
    return unless exists $cmdtable{$cmd} && (my $perm = $cmdtable{$cmd});
    return 1 if $perm & P_SYSBOT &&
	$art->{author} && $art->{author} eq 'sysbot';
    return 1 if $perm & P_ARENA && $who->isa('OurNet::BBSApp::Arena');
    return 1 if $perm & P_INVOLVED && $prop && $prop->involved &&
	(grep {$_.'.' eq $art->{author}} split(',',$prop->involved));
    return 0;
}

1;
