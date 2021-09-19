# https://leetcode.com/problems/3sum/
# Sort the list 
# With an element in sorted list nums[i], finding a pair that sum up to -nums[i] 
# Choose the pivot element as traversing through the sorted list 

# Time complexity: O(N^2) due to 
    # Finding two sum will take O(N) time, 
    # Choose pivot element will call O(N) time  
    # Sort list take O(n*log(n)) time 

# Space complexity: O(N) 

class Solution(object):
    def threeSum(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        ans = []
        nums.sort()
        
        for i in range(len(nums)):
            if (nums[i] > 0):
                break 
            if (i == 0 or nums[i-1] != nums[i]):
                self.twoSum(nums, i, ans)
                
        return ans
                
    def twoSum(self, nums, i, ans):
        low = i + 1
        high = len(nums) - 1 
        
        while (low < high):
            sum = nums[i] + nums[low] + nums[high]
            if (sum < 0):
                low +=1 
            elif (sum > 0):
                high -=1 
            else:
                ans.append([nums[i], nums[low], nums[high]])
                low +=1
                high -=1
                while (low < high and nums[low] == nums[low - 1]):
                    low +=1
        
