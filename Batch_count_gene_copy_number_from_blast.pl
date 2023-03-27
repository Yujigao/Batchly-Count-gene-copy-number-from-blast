use strict;
open (SPECIES,"$ARGV[1]") or die; ### species list file
while (<SPECIES>)
{
chomp;
push @name,$_;
}
open (OT2,">$ARGV[0].stat.txt") or die;### $ARGV[0] is the common_name of gene

open (GENEFASTA,"$ARGV[0].fasta") or die; ### fasta file (name lines like: >common_name:accession_name)
my @ges;

my %re1;
while(<GENEFASTA>)
{
chomp;
if ($_=~/>/)
{
my @arr=split(/\s+/,$_);
$arr[0]=~s/>//;
my @brr=split(/:/,$arr[0]);
$re1{$brr[0]}++;
if ($re1{$brr[0]}==1)
{
push @ges,$brr[0];
}
}
}


for (my $i=0;$i<=$#name;$i++)
{
open (BL,"$ARGV[0]_$name[$i].1e-3.blastp") or die;
open (OT,">new.$ARGV[0]_$name[$i].1e-3.blastp") or die;  ### filtered blast file
my %fenbie;
my %hash1;
my %only;
while(<BL>)
{
chomp;
my@arr=split(/\t/,$_);
if ($arr[2]<40){next}
if ($arr[-1]<100){next}
my @brr=split(/:/,$arr[0]);
my $pair=$brr[0]."\t".$arr[1];
$hash1{$pair}++;
if ($hash1{$pair}==1 and $only{$arr[1]}<1)
{
$fenbie{$brr[0]}++;
$only{$arr[1]}++;
print OT "$_\n";
}

}
for (my $j=0;$j<=$#ges;$j++)
{
print OT2 "$name[$i]\t$ges[$j]\t$fenbie{$ges[$j]}\t";
}

print OT2 "\n";
}
