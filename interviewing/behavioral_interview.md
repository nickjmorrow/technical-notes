# Behavioral Questions

TODO:

- Have a "framework" for answering these questions (STAR).
- Review and update my answers to each of these questions.
- Prepare questions for the interviewer that are non-technical that they would be able to answer.

## Generic

### Tell me about yourself

### What is a time you had a conflict with a team member, and how did you resolve it?

### What is something your team can improve on?

### What are you actively trying to improve on?

### What was a big hurdle you had on a project and how did you overcome it?

### Why are you switching jobs?

### How do you handle connflict / anger?

### Tell me about a time you disagreed with a team lead / tech lead / product manager?

### Where do you see yourself in 5 years?

- A go-to person for an application or set of applications
- Ownership over the technical design and how it evolves
- Care about testing, rollout, usage, scalability, use cases

### Why did you leave your previous company?

- Curiousity about other companies and how they do things
  - provide estimates
  - team structure
  - technical ownership and design
- Desire to work on applications that sees more users

### Tell me a little bit about yourself.

- graduated in 2017 from university of virginia with a degree in chemical engineering
- fell in love with tech, software engineering
- already had coded a lot in college, but mainly for engineering applications
- joined a company that was then acquired by mastercard
- worked on a main product for a while that enables financial institutions to make data-driven decisions, essentially letting people perform data science on the mastercard transaction log
- now on a team that focuses on the scalability of the previous product, because that product requires a lot of client-specific setup. we're trying to go from a 3-week buffer for setting up an instance to instant.

### Tell me an example of problem-solving.

- Mastermind queries

### What is your biggest weakness?

- I'm not good at asking for help

### Tell me about a time where you disagreed with someone.

- resx implementation
- mastermind query implementation
- QAE training

### Tell me an example of creativity.

- Geospatial data

### Tell me an example of collaboration.

- discuss what to prioritize for mic 2.0 instances

* Collaboration on resx

### Explain a difficult project you recently worked on.

- Rolling out isClientSpecific to many clients

### Can you give a story of what you should've done differently on a past project?

- MapClustering, which I had planned it out more

### What's something you've QAd that you're proud of?

- About a year ago we transitioned our app from Javascript to Typescript, and I volunteered to QA that initiative and ensure no new bugs were introduced. I'm really happy with that because the test plan was just very detailed, very clear, it touched on all the major use cases of the FE, the edge cases, checking for strange interactions between features or areas of the product that were notoriously fragile. I also wrote it, and then had vacation the next day, so the four engineers that were doing the coding also executed it, and there were little to no questions about various test cases. I think that really exemplified strong QAing and efficiently distributing work.

### What's something you've QAd that was very challenging or didn't go well?

- Towards the beginning of my career, I transitioned onto a team that handled a lot of data processing and transformation. The feature I was working on was very complex, both from a business / client standpoint and from a technical perspective. I was really out of my depth and should've expressed that to the team lead so that we could review a bit more of the code base. And I should've explained to the PM that I didn't fully understand what the expected calculation would look like.

### What's your team structure like? How do you report to your team lead?

- I work with four other software engineers. I have two team leads, one that takes a broader role that informs team direction and long-term goals. The other is more technical and cares more about feature and application architecture. We follow agile and have two week sprints.

### Why are you transitioning from QAE to SE?

- As a QAE, I felt a really broad responsiblity for the success of the product, but it ultimately felt technically shallow. I didn't feel like I was really learning new technical skills or becoming a significantly stronger engineer over time. I was getting better at following quality processes and maintaining the quality of our applications, but I was envious of software engineers that were able to learn more deeply about areas of the code base. I also just really enjoy writing features and feeling responsible for being able to drive business value by meeting some use case.

### What technical projects have you worked on / what have you done in your role?

- Geospatial map setup
  - So, it's a product that lets clients perform data science using the Mastercard transaction log. You can create bar charts, trend lines, donut charts, and maps, among other visualizations. So on a map, you would be able to see spend per active account for the client for each of the US states. To display a map, you need shapefiles that describe how the map is drawn, what the state of Virginia looks like. And in our infrastructural model, we have a database for each client. Before, we would populate those shape files in that database on a per-client basis, which worked when we only had 5 clients, but quickly became difficult when we grew to 50. So I wrote an automated job that would repeatedly ensure all clients have their shapefiles populated. US clients get access to US maps, while LAC clients get access to LAC maps. Additionally, shapefiles can sometimes change. Rarely, but something like a county boundary can change year to year. Before, we would have to manually recopy over shape files to all clients. Now, we just restate them at a weekly cadence.
- Database setting management
  - A lot of the product's functionality is controlled by database settings. We basically provide a single application that can follow four overarching use cases. The two main use cases are "I'm a merchant who cares about merchant-oriented analytic insights" and "I'm a financial institution who cares about issuer-oriented analytic insights." But there are also many smaller database settings like how numbers are masked and whether certain features are enabled. The client services team used to rely heavily on the engineering team to manage this, but I created a frontend that would allow a business consultant to easily disable and enable features or change parts of the product's functionality.

## Company-Specific

### What does the company do?

- provides online, international money transfer
- good for entrepreneurs / organizations, lets them transact globally
- lets companies pay people that work overseas

### What excites me about working in the company's industry?

- i really like the story of being able to take in a client and provide them solutions for growing their company internationally and seeing them succeed because of our product

### What challenges does the company face?

- scalability?

### What differentiates them from their competitors?

- fee structure

### What do employees say about the company on Glassdoor?

### What interested you about the company?

The company goal of empowering businesses and entrepreneurs to use technology to augment and optimize parts of their operations really appealed to me because taking in a smaller businness or entrepreneur as a client and providing solutions for them to expand and grow just seemed very positive and rewarding.

I also liked the company values of '
excellence' and 'passion'. I'd really like to work at a place that not only meets customer expectations, but tries to go above and beyond and find new ways to enable customers to solve their problems.

### What interested you about the position?

- want to be someone that "owns" a product and is responsible for its success
- care about the design, implementation, testing, rollout, and whether clients can engage with it
- full-stack role would be very in-sync with that drive
