$startDate = [DateTime]"2025-08-01"
$endDate = [DateTime]"2025-08-31"
$email = "daniellopezorta39@gmail.com"
$name = "daniellopez882"

# Ensure we are in a clean state if needed, but we'll just continue in the current repo
# Create activity file
if (-not (Test-Path "activity.txt")) {
    New-Item -Path "activity.txt" -ItemType File
}

for ($date = $startDate; $date -le $endDate; $date = $date.AddDays(1)) {
    # Dark green: 12-18 commits per day
    $numCommits = Get-Random -Minimum 12 -Maximum 19
    
    Write-Host "Generating $numCommits commits for $($date.ToShortDateString())..."
    
    for ($i = 1; $i -le $numCommits; $i++) {
        $hour = Get-Random -Minimum 5 -Maximum 22 # Wider time range
        $minute = Get-Random -Minimum 0 -Maximum 60
        $second = Get-Random -Minimum 0 -Maximum 60
        
        $commitDate = Get-Date -Year $date.Year -Month $date.Month -Day $date.Day -Hour $hour -Minute $minute -Second $second
        $dateStr = $commitDate.ToString("yyyy-MM-ddTHH:mm:ss")
        
        "August Contribution: $dateStr - seq $i" | Out-File -FilePath "activity.txt" -Append
        
        $env:GIT_AUTHOR_DATE = $dateStr
        $env:GIT_COMMITTER_DATE = $dateStr
        $env:GIT_AUTHOR_EMAIL = $email
        $env:GIT_COMMITTER_EMAIL = $email
        $env:GIT_AUTHOR_NAME = $name
        $env:GIT_COMMITTER_NAME = $name
        
        git add activity.txt
        git commit -m "Update: August activity log $dateStr" --quiet --author="$name <$email>"
    }
}

# Cleanup
Remove-Item Env:GIT_AUTHOR_DATE
Remove-Item Env:GIT_COMMITTER_DATE
Remove-Item Env:GIT_AUTHOR_EMAIL
Remove-Item Env:GIT_COMMITTER_EMAIL
Remove-Item Env:GIT_AUTHOR_NAME
Remove-Item Env:GIT_COMMITTER_NAME

Write-Host "Done! Generated dark green commits for August."
