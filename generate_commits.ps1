$startDate = [DateTime]"2025-08-01"
$endDate = [DateTime]"2025-08-31"

# Create a file to commit if it doesn't exist
if (-not (Test-Path "activity.txt")) {
    New-Item -Path "activity.txt" -ItemType File
}

for ($date = $startDate; $date -le $endDate; $date = $date.AddDays(1)) {
    # Random number of commits between 5 and 10 (inclusive)
    $numCommits = Get-Random -Minimum 5 -Maximum 11
    
    Write-Host "Generating $numCommits commits for $($date.ToShortDateString())..."
    
    for ($i = 1; $i -le $numCommits; $i++) {
        # Random time between 05:00 and 10:00
        $hour = Get-Random -Minimum 5 -Maximum 10
        $minute = Get-Random -Minimum 0 -Maximum 60
        $second = Get-Random -Minimum 0 -Maximum 60
        
        $commitDate = Get-Date -Year $date.Year -Month $date.Month -Day $date.Day -Hour $hour -Minute $minute -Second $second
        $dateStr = $commitDate.ToString("yyyy-MM-ddTHH:mm:ss")
        
        # Add some content to create a change
        "Contribution on $dateStr - increment $i" | Out-File -FilePath "activity.txt" -Append
        
        # Set Git environment variables to backdate the commit
        $env:GIT_AUTHOR_DATE = $dateStr
        $env:GIT_COMMITTER_DATE = $dateStr
        
        git add activity.txt
        git commit -m "Refactor: update activity log for $dateStr" --quiet
    }
}

# Cleanup environment variables
Remove-Item Env:GIT_AUTHOR_DATE
Remove-Item Env:GIT_COMMITTER_DATE

Write-Host "Successfully generated commits for August 2025."
