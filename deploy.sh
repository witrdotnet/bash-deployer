if [ -z "$1" -o -z "$2" -o -z "$3" ]
then 
   echo "usage : ./deploy.sh <src folder> <dest folder> <backup folder>"
   exit
fi

# get formatted date for folder and file names
vdate=$(date +"%Y-%m-%d-%H.%M.%S")
# command file
cmdFile="runDeploy_$vdate.sh"
# backup folder name
bkpFolderName="deploy-bkp_$vdate"
echo "mkdir $3/$bkpFolderName" >> $cmdFile

# process files to deploy
for file in $(ls $1)
do
   vind=$(echo "$file" | grep -o "[-_a-zA-Z0-9\.]" | grep -n _ | cut -d: -f1)
   if [ "1${vind}" = "1" ]
   then vind=5
   fi
   for file_dest in $(find $2 -name "${file:0:$vind}*" -type f -print)
   do
      echo "cp $file_dest $3/$bkpFolderName" >> $cmdFile
      dir_dest=$(dirname "$file_dest")
      echo "rm $file_dest" >> $cmdFile
      echo "cp $1/$file $dir_dest/" >> $cmdFile
   done
done

# display generated command file
chmod o+x $cmdFile
echo "deploy.sh generate bellow script :"
cat $cmdFile
echo ""
echo ""
echo "===> run shell script : $cmdFile"
