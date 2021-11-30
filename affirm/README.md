Trigger :

We could have achieved teh same requirement via Flow since it's the fture, but since Flow follows teh same pattern as trigger it doesn't gather teh cross object data so filtering out Account data from contact was tricky in Flow, so I have decided to go with the Trigger.

But if it was the Flow then we would have solved teh same ask with no code and no test class and easy to maintain.

Batch Job :

It was a simple trigger and nothing to discuss on the design. I have set teh scope to the 2000 for better performance.

LWC:

Calling the LWC from ltng:out (VF Page) was tricky since navigation service only works in lightning framework not in classic framework. I had to come up with the solution where I have encoded the new the LWC componnet and used it window replace function.