<#
	The ReplaceInFiles function will find files based on a $filter, look for all occurances of a $pattern
	and replace the matching text with $replace
#>

Param (
	[Parameter(Mandatory=$True)]
	[string]$solution
)

function ReplaceInFiles($filter, $pattern, $replace)
{
	$files = Get-ChildItem -filter $filter -exclude scaffold.ps1,.git -recurse | 
		Where { ($_.FullName -inotmatch ("^$root\packages" -replace "\\","\\") `
			-and !$_.PSIsContainer `
			-and ($_.extension -ne ".dll") `
			-and ($_.extension -ne ".pdb") `
			-and ($_.extension -ne ".exe")) ` 
		}
			
	foreach($file in $files) 
	{
		(Get-Content $file.FullName) -replace $pattern, $replace | Out-File $file.FullName -Encoding ascii
	}
}

ReplaceInFiles * "Rename\.Me" $solution
#remove git info from solution by deleting .git folder