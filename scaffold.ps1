<#
	The ReplaceInFiles function will find files based on a $filter, look for all occurances of a $pattern
	and replace the matching text with $replace
#>

Param (
	[Parameter(Mandatory=$True)]
	[string]$solution
)

function CopyFiles($destination)
{
    
    Get-ChildItem -filter * -exclude scaffold.ps1 -recurse | 
        Where {
            $_.FullName -notlike "*.git\*" `
			-and $_.FullName -notlike "*\packages\*" `
            -and (!($_.PSIsContainer)) ` 
        } | foreach{
    
            $dir = $_.DirectoryName.Replace($PSScriptRoot,$destination)
            $target = $_.FullName.Replace($PSScriptRoot,$destination)
 
            if (!(test-path($dir))) { mkdir $dir }
 
            if (!(test-path($target)))
            {
                copy-item -path $_.FullName -destination $target -recurse -force
            }
        }
}

function ReplaceInFiles($source, $pattern, $replace)
{
    echo "renaming files"

	$files = Get-ChildItem -Path $source -filter * -exclude scaffold.ps1 -recurse | 
		Where { ($_.FullName -inotmatch ("^$root\packages" -replace "\\","\\") `
            -and $_.FullName -notlike "*.git\*" `
			-and !$_.PSIsContainer `
			-and ($_.extension -ne ".dll") `
			-and ($_.extension -ne ".pdb") `
			-and ($_.extension -ne ".exe")) ` 
		}
			
	foreach($file in $files) 
	{
		(Get-Content $file.FullName) -replace $pattern, $replace | Out-File $file.FullName -Encoding ascii
        $file | Rename-Item -NewName { $_.Name -replace $pattern, $replace }
	}

    echo "renaming folders"

    Get-ChildItem -Path $source -filter * -Recurse |
        Where {
            $_.PSIsContainer `
            -and $_.Name.Contains($pattern) `
        } | Rename-Item -NewName { $_.Name -replace $pattern, $replace }

    #Dir |
    #    Where-Object { $_.Name.Contains($pattern) } |
    #    Rename-Item -NewName { $_.Name -replace $pattern, $replace }
}


#ReplaceInFiles * "Rename.Me" $solution

$solutionFolder = "..\$solution"

echo "Checking for solution folder"
if(!(Test-Path $solutionFolder))
{
    echo "creating solution folder"
    New-Item -ItemType DIRECTORY -Path $solutionFolder
    CopyFiles $solutionFolder

    echo "Renaming"
    ReplaceInFiles $solutionFolder "Rename.Me" $solution
	
	#may want to delete bin/ obj folders. They are currently copied over
}
else
{
    echo "Solution folder already exists"
}