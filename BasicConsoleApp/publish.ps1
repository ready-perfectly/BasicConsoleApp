# Script to build and package image into Minikube

param(
	[switch]$Debug,
	[string]$versionFilePath = "./version.txt"
)

$projectName = "BasicConsoleApp"
$containerImageName = "basic-console-app"

if ($Debug) { $DebugPreference = 'Continue' }

$main = {
	Push-Location
	Set-Location $PSScriptRoot

	Write-Debug "versionFilePath is: $versionFilePath" 

	$lastVersion = 	Get-LastVersion $versionFilePath
	$nextVersion = Update-Version $lastVersion

	$nextContainerImageName = "$($containerImageName):$nextVersion"
	Write-Host "Building container image: [$nextContainerImageName]"
	
	minikube image build . -t $nextContainerImageName -f .\Dockerfile
	
	# kubectl set image cronjob/test-job test-job=docker.io/library/$nextContainerImageName

	# Create a job that runs new image
	#kubectl create job my-job --image=docker.io/library/"$containerImageName:$nextVersion"
	#kubectl create job test-job --from=cronjob/test-job

	#kubectl set image deployment/featured-console-app featured-console-app=featured-console-app:$nextVersion

	# One-time setup Kubernetes cronjob setup
	#kubectl create cronjob simple-job --image=docker.io/library/simple-job-console-app:0.22 --schedule="0 */2 * * *" --dry-run=client -o yaml > .\k8s\simple-job-console-app.cronjob.yaml
	#kubectl apply -f .\k8s\simple-job-console-app.cronjob.yaml

	#kubectl create configmap simple-job-console-app --dry-run=client -o yaml > .\k8s\simple-job-console-app.configmap.yaml
	#kubectl apply -f .\k8s\simple-job-console-app.configmap.yaml

	$nextVersion.ToString() | Out-File $versionFilePath
	Pop-Location
}


# SCRIPT HELPER FUNCTIONS

Function Get-LastVersion($versionFilePath) {
	
	if (Test-Path $versionFilePath) {
		$versionText = Get-Content $versionFilePath
		Write-Debug "$versionFilePath = `"$versionText`""

		try	{
			$lastVersion = [Version]::new($versionText)
		}
		catch [System.ArgumentException], [System.FormatException] {
			$lastVersion = [version]::new("0.0")
		}
		catch {
			Write-Host $_.Exception
		}
	}

	Write-Debug "Last version was $lastVersion"
	return $lastVersion
}


Function Update-Version($lastVersion) {
	
	$nextVersion = [version]::new($lastVersion.Major, $lastVersion.Minor, $lastVersion.Build, $lastVersion.Revision + 1)
	
	Write-Debug "Next version will be $nextVersion"
	return $nextVersion
}


# MAIN
& $main

# END-OF-SCRIPT

# Other ideas:
# Auto-versioning based on what is available in Minikube
# This sounds good until we remember that it might not necessarily be Kubernetes != Minikube
# And also `minikube *` commands are all kind of slow
# $a = $(minikube image ls | Select-String featured-console-app)[0]
